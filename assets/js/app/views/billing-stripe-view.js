(function() {
  var Stripe,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Stripe = {
    setPublishableKey: function() {},
    validateCardNumber: function(x) {
      return x;
    },
    validateExpiry: function(month, year) {
      return month && year;
    },
    validateCVC: function(cvc) {
      return cvc;
    },
    cardType: function(cardNumber) {
      if (cardNumber.match(/^(51|52|53|54|55)/)) {
        return "MasterCard";
      }
      if (cardNumber.match(/^4/)) {
        return "Visa";
      }
      return 'Unknown';
    },
    createToken: function(options, callback) {
      return callback(null, 'fake_stripe_token');
    }
  };

  App.Views.StripeBilling = (function(_super) {
    var handleError;

    __extends(StripeBilling, _super);

    function StripeBilling() {
      this.onCreditCardScanSuccess = __bind(this.onCreditCardScanSuccess, this);
      return StripeBilling.__super__.constructor.apply(this, arguments);
    }

    StripeBilling.prototype.template = 'billing-stripe';

    StripeBilling.prototype.className = 'content billing-stripe';

    StripeBilling.prototype.fields = {
      'cardNumber': '#billing-card-number',
      'expiry': '#billing-expiry',
      'cvc': '#billing-cvc'
    };

    StripeBilling.prototype.events = {
      'keydown input': 'performValidation',
      'keyup    #billing-card-number': 'changeCardType',
      'keydown  #billing-card-number': 'cardNumberDigitEntered',
      'keydown  #billing-expiry': 'formatExpiry',
      'keypress #billing-cvc': 'restrictNumber',
      'click #wizard-next-step': 'wizardNextStepClicked',
      'click #scan-card-button': 'scanCardButtonClicked'
    };

    StripeBilling.prototype.cardTypes = {
      'Visa': 'visa',
      'American Express': 'amex',
      'MasterCard': 'mastercard',
      'Discover': 'discover',
      'Unknown': 'unknown'
    };

    StripeBilling.prototype.normalizeErrorCodes = {
      'card_declined': 'cardDeclined',
      'invalid_number': 'invalidCardNumber',
      'incorrect_number': 'incorrectCardNumber',
      'invalid_expiry_month': 'invalidExpiryMonth',
      'invalid_expiry_year': 'invalidExpiryYear',
      'expired_card': 'expiredCard',
      'invalid_cvc': 'invalidCvc'
    };

    StripeBilling.prototype.errorCodeToField = {
      'cardDeclined': 'cardNumber',
      'invalidCardNumber': 'cardNumber',
      'incorrectCardNumber': 'cardNumber',
      'expiredCard': 'cardNumber',
      'invalidExpiryMonth': 'expiry',
      'invalidExpiryYear': 'expiry',
      'invalidCvc': 'cvc'
    };

    StripeBilling.prototype.initialize = function(options) {
      var itemspot, key;
      StripeBilling.__super__.initialize.apply(this, arguments);
      key = options.key, itemspot = options.itemspot;
      this.setKey(key);
      this.setView('.order-table', new App.Views.OrderTable({
        itemspot: itemspot
      }));
      return this.performValidation();
    };

    StripeBilling.prototype.setKey = function(key) {
      this.key = key;
      return Stripe.setPublishableKey(this.key);
    };

    StripeBilling.prototype.getFieldValues = function() {
      var expiryMonth, expiryYear, fieldValues, _ref, _ref1;
      fieldValues = StripeBilling.__super__.getFieldValues.call(this);
      _ref1 = (_ref = fieldValues.expiry) != null ? _ref.split(' / ') : void 0, expiryMonth = _ref1[0], expiryYear = _ref1[1];
      expiryMonth || (expiryMonth = '');
      expiryYear || (expiryYear = '');
      return _.extend(fieldValues, {
        expiryMonth: expiryMonth,
        expiryYear: expiryYear
      });
    };

    StripeBilling.prototype.validateForm = function(callbacks) {
      var fieldValues, invalidFields, name, value, _ref;
      this.clearFieldErrors();
      fieldValues = this.getFieldValues();
      invalidFields = (function() {
        var _results;
        _results = [];
        for (name in fieldValues) {
          value = fieldValues[name];
          if ((value != null ? value.length : void 0) === 0) {
            _results.push(name);
          }
        }
        return _results;
      })();
      if (!_.isEmpty(invalidFields || !((_ref = fieldValues.cvc.length) === 3 || _ref === 4))) {
        return typeof callbacks.error === "function" ? callbacks.error('Fill in all fields') : void 0;
      }
      if (!Stripe.validateCardNumber(fieldValues.cardNumber)) {
        return typeof callbacks.error === "function" ? callbacks.error('Invalid card number') : void 0;
      }
      if (!Stripe.validateExpiry(fieldValues.expiryMonth, fieldValues.expiryYear)) {
        return typeof callbacks.error === "function" ? callbacks.error('Invalid card expiry') : void 0;
      }
      if (!Stripe.validateCVC(fieldValues.cvc)) {
        return typeof callbacks.error === "function" ? callbacks.error('Invalid CVC') : void 0;
      }
      return callbacks.success(fieldValues);
    };

    StripeBilling.prototype.performValidation = function(event) {
      var _this = this;
      return _.defer(function() {
        var $button;
        $button = $('#wizard-next-step');
        return _this.validateForm({
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

    StripeBilling.prototype.beforeNextStep = function(done) {
      var _this = this;
      if (this.pending) {
        return;
      }
      this.enablePending();
      return this.validateForm({
        error: function(errorMessage) {
          console.error(errorMessage);
          return this.disablePending();
        },
        success: function(cleanedFields) {
          _this.disablePending();
          return _this.createToken(cleanedFields, {
            error: function(error) {
              return console.error(error);
            },
            success: function(response) {
              console.debug("Stripe#createToken success:\n", response);
              return done({
                token: response
              });
            }
          });
        }
      });
    };

    StripeBilling.prototype.createToken = function(fieldValues, callbacks) {
      var complete;
      complete = function(status, response) {
        if (response.error) {
          return typeof callbacks.error === "function" ? callbacks.error(response.error) : void 0;
        }
        return typeof callbacks.success === "function" ? callbacks.success(response) : void 0;
      };
      fieldValues = this.getFieldValues();
      return Stripe.createToken({
        number: fieldValues.cardNumber,
        exp_month: fieldValues.expiryMonth,
        exp_year: fieldValues.expiryYear,
        cvc: fieldValues.cvc
      }, complete);
    };

    StripeBilling.prototype.cardNumberDigitEntered = function(event) {
      var _this = this;
      return this.formatNumberField(event, function(digit) {
        var cardNumber, lastDigitsRegex, maxlength, rawCardNumber;
        if (digit == null) {
          digit = '';
        }
        rawCardNumber = (_this.getFieldValue('cardNumber')) + digit;
        cardNumber = _this.digitGroups(' ', /(\d{4})/g, rawCardNumber);
        if ((Stripe.cardType(cardNumber)) === 'American Express') {
          lastDigitsRegex = /^(\d{4}|\d{4}\s\d{6})$/;
          maxlength = 16;
        } else {
          lastDigitsRegex = /(?:^|\s)(\d{4})$/;
          maxlength = 19;
        }
        if (cardNumber.length <= maxlength) {
          return _this.setFieldValue('cardNumber', cardNumber);
        }
      });
    };

    StripeBilling.prototype.formatExpiry = function(event) {
      var _this = this;
      return this.formatNumberField(event, function(digit) {
        var expiry;
        if (digit == null) {
          digit = '';
        }
        expiry = (_this.getFieldValue('expiry')) + digit;
        expiry = _this.digitGroups(' / ', /(\d{2})/g, expiry);
        if (expiry.length <= 7) {
          return _this.setFieldValue('expiry', expiry);
        }
      });
    };

    StripeBilling.prototype.digitGroups = function(join, regex, cardNumber) {
      var digitGroups;
      cardNumber = cardNumber.replace(/[^\d]+/g, '');
      digitGroups = cardNumber.split(regex);
      digitGroups = _.reject(digitGroups, function(digitGroup) {
        return !digitGroup;
      });
      return digitGroups.join(join);
    };

    StripeBilling.prototype.formatNumberField = function(event, formatter) {
      var digit, _ref;
      if (event.metaKey) {
        return true;
      }
      if (event.which === 8) {
        _.defer(formatter);
        return true;
      }
      if ((_ref = event.which) === 9 || _ref === 37 || _ref === 39) {
        return true;
      }
      digit = String.fromCharCode(event.which);
      if (!(/^\d+$/.test(digit))) {
        return false;
      }
      formatter(digit);
      return false;
    };

    StripeBilling.prototype.restrictNumber = function(event) {
      var char;
      if (event.shiftKey || event.metaKey) {
        return true;
      }
      if (event.which === 0) {
        return true;
      }
      char = String.fromCharCode(event.which);
      return !/[A-Za-z]/.test(char);
    };

    StripeBilling.prototype.changeCardType = function(event) {
      var $cardNumber, map, name, type, _ref;
      type = Stripe.cardType(this.getFieldValue('cardNumber'));
      $cardNumber = this.getField('cardNumber');
      if (!$cardNumber.hasClass(type)) {
        _ref = this.cardTypes;
        for (name in _ref) {
          map = _ref[name];
          $cardNumber.removeClass(map);
        }
        return $cardNumber.addClass(this.cardTypes[type]);
      }
    };

    handleError = function(err) {
      var fieldName, normalizedErrorCode;
      console.error("Stripe error: " + err.message);
      normalizedErrorCode = normalizeErrorCodes[err.code];
      if (!normalizedErrorCode) {
        return;
      }
      fieldName = errorCodeToField[normalizedErrorCode];
      return this.setFieldError(fieldName);
    };

    StripeBilling.prototype.expiryVal = function() {
      var month, prefix, trim, year;
      trim = function(s) {
        return s.replace(/^\s+|\s+$/g, '');
      };
      month = trim(this.getFieldValue('expiryMonth'));
      year = trim(this.getFieldValue('expiryYear'));
      if (year.length === 2) {
        prefix = (new Date).getFullYear();
        prefix = prefix.toString().slice(0, 2);
        year = prefix + year;
      }
      return {
        month: month,
        year: year
      };
    };

    StripeBilling.prototype.scanCardButtonClicked = function() {
      var controller, scanOptions;
      controller = new App.Controllers.CardIO(App.config.cardio.key);
      scanOptions = {
        disableManualEntryButtons: true,
        collectExpiry: true,
        collectCVV: true
      };
      return controller.scan(scanOptions, {
        success: this.onCreditCardScanSuccess
      });
    };

    StripeBilling.prototype.onCreditCardScanSuccess = function(_arg) {
      var cardNumber, cvv, expiryMonth, expiryYear, formatExpiry;
      cardNumber = _arg.cardNumber, expiryMonth = _arg.expiryMonth, expiryYear = _arg.expiryYear, cvv = _arg.cvv;
      formatExpiry = function(expiryMonth, expiryYear) {
        var expiry;
        expiryYear = String(expiryYear).slice(2);
        return expiry = "" + expiryMonth + " / " + expiryYear;
      };
      this.setFieldValue('cardNumber', cardNumber);
      this.setFieldValue('expiry', formatExpiry(expiryMonth, expiryYear));
      this.setFieldValue('cvc', cvv);
      return this.performValidation();
    };

    return StripeBilling;

  })(App.Views.WizardStep);

  App.Controllers.CardIO = (function() {

    function CardIO(key) {
      this.key = key;
      console.debug("CardIO using key: " + this.key);
    }

    CardIO.prototype.scan = function(options, callbacks) {
      var cancelled, dummy, success, _ref;
      if (callbacks == null) {
        callbacks = {};
      }
      _ref = (callbacks ? callbacks : options), success = _ref.success, cancelled = _ref.cancelled;
      dummy = (function() {});
      return this._callPlugin(this.key, options, success || dummy, cancelled || dummy);
    };

    CardIO.prototype._callPlugin = function(key, options, onSuccess, onError) {
      return window.plugins.card_io.scan(key, options, onSuccess, onError);
    };

    return CardIO;

  })();

}).call(this);
