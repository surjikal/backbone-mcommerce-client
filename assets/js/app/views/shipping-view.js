(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.Shipping = (function(_super) {

    __extends(Shipping, _super);

    function Shipping() {
      return Shipping.__super__.constructor.apply(this, arguments);
    }

    Shipping.prototype.template = 'shipping';

    Shipping.prototype.className = 'shipping-view';

    Shipping.prototype.currentAddressMode = null;

    Shipping.prototype.currentAddressModeView = null;

    Shipping.prototype.addressModeSetters = null;

    Shipping.prototype.events = _.extend({}, App.Views.WizardStep.prototype.events, {
      'click #toggle-address-mode': 'toggleAddressMode',
      'click #show-login-popup': 'showLoginPopup',
      'keydown input': 'performValidation'
    });

    Shipping.prototype.initialize = function(options) {
      var itemspot, refresh,
        _this = this;
      Shipping.__super__.initialize.apply(this, arguments);
      itemspot = options.itemspot;
      this.collection.on('remove', function() {
        if (_this.collection.isEmpty()) {
          return _this.render();
        }
      });
      this.addressModeSetters = {
        'create': this.setAddressCreateView,
        'select': this.setAddressSelectView
      };
      this.setAddressSelectMode();
      refresh = function() {
        return App.router.navigate(itemspot.getCheckoutUrl(), {
          trigger: true
        });
      };
      return App.auth.events.on('login', refresh, this);
    };

    Shipping.prototype.performValidation = function(event) {
      var _this = this;
      return _.defer(function() {
        var $button;
        $button = _this.$('#wizard-next-step');
        return _this.currentAddressModeView.validateForm({
          error: function(message) {
            $button.text(message);
            return $button.attr('disabled', true);
          },
          success: function(cleanedFields) {
            $button.text('Continue');
            return $button.removeAttr('disabled');
          }
        });
      });
    };

    Shipping.prototype.beforeNextStep = function(done) {
      var _this = this;
      if (this.pending) {
        return;
      }
      this.enablePending();
      return this.currentAddressModeView.validateForm({
        success: function(cleanedFields) {
          return _this.currentAddressModeView.submitForm(cleanedFields, {
            error: function() {
              return _this.disablePending();
            },
            success: function(data) {
              _this.disablePending();
              _this._addUrlParameter('address', data.address.get('id'));
              return done(data);
            }
          });
        }
      });
    };

    Shipping.prototype.beforeRender = function() {
      Shipping.__super__.beforeRender.apply(this, arguments);
      if (this.collection.isEmpty()) {
        console.debug("Addresses empty.");
        this.setAddressCreateMode();
      }
      return this.addressModeSetters[this.currentAddressMode].call(this);
    };

    Shipping.prototype.toggleAddressMode = function() {
      this.currentAddressMode = this.getNextAdddressMode();
      return this.render();
    };

    Shipping.prototype.setAddressCreateMode = function() {
      this.currentAddressMode = 'create';
      return this.$('#toggle-address-mode').text('cancel');
    };

    Shipping.prototype.setAddressSelectMode = function() {
      this.currentAddressMode = 'select';
      return this.$('#toggle-address-mode').text('+ address');
    };

    Shipping.prototype.getNextAdddressMode = function() {
      if (this.currentAddressMode === 'create') {
        return 'select';
      } else {
        return 'create';
      }
    };

    Shipping.prototype.setAddressCreateView = function() {
      console.debug('Setting address create view.');
      this.setAddressCreateMode();
      return this.setAddressView(new App.Views.AddressCreate({
        collection: this.collection
      }));
    };

    Shipping.prototype.setAddressSelectView = function() {
      console.debug('Setting address select view.');
      this.setAddressSelectMode();
      return this.setAddressView(new App.Views.AddressSelect({
        collection: this.collection
      }));
    };

    Shipping.prototype.setAddressView = function(addressModeView) {
      this.currentAddressModeView = addressModeView;
      this.setView('#address-mode', addressModeView);
      return this.performValidation();
    };

    Shipping.prototype.showLoginPopup = function() {
      var _this = this;
      return App.views.main.showPopup(new App.Views.LoginPopup({
        callbacks: {
          success: function() {
            _this.render();
            return App.views.main.removePopup();
          }
        }
      }));
    };

    Shipping.prototype.serialize = function() {
      return {
        showModeToggleButton: !this.collection.isEmpty(),
        toggleButtonText: this.currentAddressMode === 'create' ? 'cancel' : '+ address',
        user: App.auth.user.isLoggedIn() ? App.auth.user.toJSON() : void 0
      };
    };

    Shipping.prototype.close = function() {
      console.debug("Cleaning up shipping view.");
      return App.auth.events.off(null, null, this);
    };

    return Shipping;

  })(App.Views.WizardStep);

}).call(this);
