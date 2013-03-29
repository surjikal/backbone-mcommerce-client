(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.PurchaseWizard = (function(_super) {

    __extends(PurchaseWizard, _super);

    function PurchaseWizard() {
      return PurchaseWizard.__super__.constructor.apply(this, arguments);
    }

    PurchaseWizard.prototype.className = 'purchase-wizard';

    PurchaseWizard.prototype.initialize = function(options) {
      var addresses, params,
        _this = this;
      console.debug("Initializing purchase wizard.");
      this.itemspot = options.itemspot, this.done = options.done, params = options.params;
      addresses = App.auth.user.getAddresses();
      App.auth.events.on('logout', function() {
        return App.router.navigate(_this.itemspot.getRouterUrl(), {
          trigger: true
        });
      }, this);
      if (params.address) {
        options.wizardData = {
          address: addresses.get(params.address)
        };
      }
      this.steps = [
        {
          id: 'shipping',
          title: 'Shipping',
          icon: 'home',
          initialize: function(options) {
            return function(wizardData) {
              return new App.Views.Shipping(_.extend(options, {
                collection: addresses,
                itemspot: _this.itemspot,
                wizardData: wizardData
              }));
            };
          }
        }, {
          id: 'billing',
          title: 'Billing',
          icon: 'tag',
          initialize: function(options) {
            return function(wizardData) {
              var ViewClass;
              ViewClass = App.config.useStripe ? App.Views.StripeBilling : App.Views.PaypalBilling;
              return new ViewClass(_.extend(options, {
                collection: addresses,
                itemspot: _this.itemspot,
                params: params,
                wizardData: wizardData,
                key: App.config.useStripe ? App.config.stripe.key : void 0
              }));
            };
          }
        }, {
          id: 'confirm',
          title: 'Confirm',
          icon: 'user',
          initialize: function(options) {
            return function(wizardData) {
              return new App.Views.Confirm(_.extend(options, {
                itemspot: _this.itemspot,
                wizardData: wizardData
              }));
            };
          }
        }
      ];
      return PurchaseWizard.__super__.initialize.apply(this, arguments);
    };

    PurchaseWizard.prototype.getStepUrl = function(stepId) {
      return "" + (this.itemspot.getCheckoutUrl()) + "/" + stepId;
    };

    PurchaseWizard.prototype.onUnmetDependencies = function(message) {
      PurchaseWizard.__super__.onUnmetDependencies.apply(this, arguments);
      return App.router.navigate("" + (this.itemspot.getRouterUrl()), {
        trigger: true,
        replace: true
      });
    };

    PurchaseWizard.prototype.completed = function(wizardData, completeLastStep) {
      var finish,
        _this = this;
      console.debug('Purchase wizard has been completed.');
      finish = function() {
        completeLastStep();
        return _this.done(wizardData);
      };
      if (App.auth.user.isLoggedIn()) {
        return finish();
      }
      return this._showRegistrationPopup(finish);
    };

    PurchaseWizard.prototype._showRegistrationPopup = function(done) {
      var popup,
        _this = this;
      popup = new App.Views.RegistrationPopup({
        model: App.auth.user,
        callbacks: {
          skipped: function() {
            console.debug("Registration was skipped.");
            popup.close();
            return done();
          },
          success: function() {
            console.debug("Registration was a success.");
            popup.close();
            return done();
          }
        }
      });
      return App.views.main.showPopup(popup);
    };

    PurchaseWizard.prototype.cleanup = function() {
      console.debug("Cleaning up purchase wizard view.");
      return App.auth.events.off(null, null, this);
    };

    return PurchaseWizard;

  })(App.Views.Wizard);

}).call(this);
