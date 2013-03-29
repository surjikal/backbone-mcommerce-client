(function() {
  var MockPaypalBillingController, PaypalBillingController,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.PaypalBilling = (function(_super) {

    __extends(PaypalBilling, _super);

    function PaypalBilling() {
      this.handleCheckoutCancelled = __bind(this.handleCheckoutCancelled, this);
      return PaypalBilling.__super__.constructor.apply(this, arguments);
    }

    PaypalBilling.prototype.template = 'billing-paypal';

    PaypalBilling.prototype.className = 'content billing-paypal';

    PaypalBilling.prototype.dependencies = ['address'];

    PaypalBilling.prototype.initialize = function(options) {
      var params, user,
        _this = this;
      PaypalBilling.__super__.initialize.apply(this, arguments);
      this.itemspot = options.itemspot, user = options.user, params = options.params;
      this.address = options.wizardData.address;
      this.controller = App.config.paypal.useMockController ? new MockPaypalBillingController() : new PaypalBillingController();
      if (params.callback) {
        return _.defer(function() {
          return _this.handleCallback(params);
        });
      }
      return this.setView('.order-table', new App.Views.OrderTable({
        itemspot: this.itemspot
      }));
    };

    PaypalBilling.prototype.beforeNextStep = function() {
      var _this = this;
      this.enablePending(-1);
      return this.controller.getToken(this.address, this.itemspot, {
        success: function(response) {
          return _this.handleToken(response.token);
        },
        error: function() {
          _this.disablePending();
          return alert('Something went wrong. Please try again!');
        }
      });
    };

    PaypalBilling.prototype.handleToken = function(token) {
      console.debug("Received token: " + token);
      return this.controller.showCheckoutPage(token, this.collection, this.address, this.itemspot);
    };

    PaypalBilling.prototype.handleCallback = function(params) {
      switch (params.callback) {
        case "success":
          if (!params.PayerID) {
            throw new Error("Did not receive PayerID from PayPal checkout.");
          }
          return this.handleCheckoutSuccess(this.address, params.PayerID);
        case "cancelled":
          return this.handleCheckoutCancelled(this.address);
        default:
          throw new Error("Callback is empty.");
      }
    };

    PaypalBilling.prototype.handleCheckoutSuccess = function(address, payerId) {
      console.debug("PayPal payment authorization was successful.");
      return this.completed({
        address: address,
        payerId: payerId
      });
    };

    PaypalBilling.prototype.handleCheckoutCancelled = function(address) {
      this.address = address;
      return console.debug("PayPal payment authorization was cancelled.");
    };

    return PaypalBilling;

  })(App.Views.WizardStep);

  PaypalBillingController = (function() {

    function PaypalBillingController() {}

    PaypalBillingController.prototype.getToken = function(address, itemspot, callbacks) {
      var cancelUrl, successUrl, _ref;
      _ref = this._getCallbackUrls(itemspot), successUrl = _ref[0], cancelUrl = _ref[1];
      return App.api.purchase.getToken(address, itemspot, successUrl, cancelUrl, callbacks);
    };

    PaypalBillingController.prototype.showCheckoutPage = function(token, addresses, address, itemspot) {
      var phonegap, website,
        _this = this;
      phonegap = function() {
        return console.debug("NOT IMPLEMENTED");
      };
      website = function() {
        console.debug("Opening paypal page...");
        return _this._openPaypalCheckoutPage(token);
      };
      if (App.isPhonegap) {
        return phonegap();
      } else {
        return website();
      }
    };

    PaypalBillingController.prototype._openPaypalCheckoutPage = function(token) {
      var paypalUrl;
      paypalUrl = this._getPaypalUrl(token);
      return window.location.href = paypalUrl;
    };

    PaypalBillingController.prototype._getPaypalUrl = function(token) {
      return "" + App.config.urls.paypal.base + "/cgi-bin/webscr?cmd=_express-checkout&token=" + token;
    };

    PaypalBillingController.prototype._getCallbackUrls = function(itemspot) {
      var urlPrefix;
      urlPrefix = this._getCallbackUrlPrefix();
      return ["" + urlPrefix + "success", "" + urlPrefix + "cancel"];
    };

    PaypalBillingController.prototype._getCallbackUrlPrefix = function() {
      var separator;
      separator = window.location.search ? '&' : '?';
      return "" + window.location.href + separator + "callback=";
    };

    return PaypalBillingController;

  })();

  MockPaypalBillingController = (function(_super) {

    __extends(MockPaypalBillingController, _super);

    function MockPaypalBillingController() {
      return MockPaypalBillingController.__super__.constructor.apply(this, arguments);
    }

    MockPaypalBillingController.prototype.FAKE_TOKEN = 'omgwtfbbq';

    MockPaypalBillingController.prototype.FAKE_PAYER_ID = 'lolsecret';

    MockPaypalBillingController.prototype.getToken = function(address, itemspot, callbacks) {
      var cancelUrl, successUrl, _ref;
      _ref = this._getCallbackUrls(itemspot), successUrl = _ref[0], cancelUrl = _ref[1];
      return callbacks.success({
        token: successUrl
      });
    };

    MockPaypalBillingController.prototype._openPaypalCheckoutPage = function(successUrl) {
      var url;
      alert("I'm pretending to be PayPal! Shall we continue?");
      url = "" + successUrl + "&PayerID=" + this.FAKE_PAYER_ID;
      return window.location.href = url;
    };

    return MockPaypalBillingController;

  })(PaypalBillingController);

}).call(this);
