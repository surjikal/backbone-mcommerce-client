(function() {
  var PostalCodeUtils,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.AddressCreate = (function(_super) {

    __extends(AddressCreate, _super);

    function AddressCreate() {
      return AddressCreate.__super__.constructor.apply(this, arguments);
    }

    AddressCreate.prototype.template = 'address-create';

    AddressCreate.prototype.className = 'address-create';

    AddressCreate.prototype.fields = {
      postalCode: '#shipping-postalcode',
      firstName: '#shipping-firstname',
      lastName: '#shipping-lastname',
      street: '#shipping-street'
    };

    AddressCreate.prototype.validateForm = function(callbacks) {
      var fieldValues, invalidFields, name, postalCode, validPostalCode, value;
      fieldValues = this.getFieldValues();
      invalidFields = (function() {
        var _results;
        _results = [];
        for (name in fieldValues) {
          value = fieldValues[name];
          if (value.length === 0) {
            _results.push(name);
          }
        }
        return _results;
      })();
      if (!_.isEmpty(invalidFields)) {
        return typeof callbacks.error === "function" ? callbacks.error('Fill in all fields') : void 0;
      }
      postalCode = fieldValues.postalCode;
      validPostalCode = PostalCodeUtils.validate(postalCode);
      if (!validPostalCode) {
        return typeof callbacks.error === "function" ? callbacks.error('Please enter a valid postal/zip code') : void 0;
      }
      return typeof callbacks.success === "function" ? callbacks.success(fieldValues) : void 0;
    };

    AddressCreate.prototype.submitForm = function(cleanedFields, callbacks) {
      var address;
      if (App.config.offlineMode) {
        address = new App.Models.Address(cleanedFields);
        this.collection.add(address);
        return callbacks.success({
          address: address
        });
      }
      return this.collection.create(cleanedFields, {
        success: function(address) {
          return callbacks.success({
            address: address
          });
        }
      });
    };

    return AddressCreate;

  })(App.Views.AddressModeView);

  PostalCodeUtils = (function() {
    return {
      validate: function(postalCode) {
        var isPostal, isZip;
        if (!postalCode) {
          return false;
        }
        isZip = (postalCode.match(/[0-9]{5}/i)) !== null;
        isPostal = (postalCode.match(/[a-z][0-9][a-z] ?[0-9][a-z][0-9]/i)) !== null;
        return isZip || isPostal;
      },
      sanitize: function(postalCode) {
        return postalCode.replace(' ', '');
      },
      getCityAndProvince: function(postalCode, callbacks) {
        var sanitizedPostalCode, url;
        sanitizedPostalCode = this.sanitizePostalCode(postalCode);
        url = this._getCityAndProvinceLookupUrl(sanitizedPostalCode, 'canada');
        return $.getJSON(url, function(data) {
          var errorCode, errorMessage, noResultsFound, result;
          errorCode = parseInt(data.ResultSet.Error);
          errorMessage = data.ResultSet.ErrorMessage;
          if (errorCode !== 0) {
            return callbacks.error(errorCode, errorMessage, data);
          }
          noResultsFound = data.ResultSet.Found === 0;
          if (noResultsFound) {
            return callbacks.noResultsFound();
          }
          result = data.ResultSet.Results[0];
          return callbacks.success({
            city: result.city,
            province: result.state,
            country: result.country
          });
        });
      },
      _getCityAndProvinceLookupUrl: function(postalCode, country) {
        return "http://where.yahooapis.com/geocode?q=" + postalCode + "," + country + "&flags=J";
      }
    };
  })();

}).call(this);
