(function() {
  var getBoutiqueOrShowNotFound, getItemSpotOrShowNotFound,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      '': 'index',
      'login': 'login',
      'boutiques/:code': 'boutique',
      'boutiques/:code/notFound': 'boutiqueNotFound',
      'boutiques/:boutiqueCode/items/:index': 'itemspot',
      'boutiques/:boutiqueCode/items/:index/checkout': 'purchaseWizard',
      'boutiques/:boutiqueCode/items/:index/checkout/:step': 'purchaseWizard',
      'boutiques/:boutiqueCode/items/:index/thanks': 'thanks',
      'boutiques/:boutiqueCode/items/:index/notFound': 'itemspotNotFound',
      '*_': 'routeNotFound'
    };

    Router.prototype.initialize = function() {
      return console.debug('Initializing router.');
    };

    Router.prototype.index = function() {
      return this.boutique('trolley');
    };

    Router.prototype.boutiqueSelect = function() {
      console.debug('Routing to boutique select.');
      return App.views.main.setPageView(new App.Views.BoutiqueSelect(), true);
    };

    Router.prototype.login = function(params) {
      var next;
      console.debug("Routing to login. Params: " + params);
      next = (params != null ? params.next : void 0) || '/';
      return App.views.main.setPageView(new App.Views.Auth({
        callbacks: {
          success: function() {
            return alert("Login success!");
          }
        }
      }));
    };

    Router.prototype.boutique = function(code) {
      console.debug('Routing to boutique.');
      return getBoutiqueOrShowNotFound(code, function(boutique) {
        return App.views.main.setPageView(new App.Views.Boutique({
          model: boutique
        }));
      });
    };

    Router.prototype.itemspot = function(boutiqueCode, index) {
      console.debug('Routing to itemspot.');
      return getItemSpotOrShowNotFound(boutiqueCode, index, function(itemspot) {
        return App.views.main.setPageView(new App.Views.ItemSpot({
          model: itemspot
        }));
      });
    };

    Router.prototype.purchaseWizard = function(boutiqueCode, index, step, params) {
      if (params == null) {
        params = {};
      }
      console.debug('Routing to purchase wizard.');
      return getItemSpotOrShowNotFound(boutiqueCode, index, function(itemspot, boutique) {
        var fetchUserAndShowPurchaseWizard, purchaseWizardCompleted, showNewUserPurchaseWizard, showPurchaseWizard, user;
        if (_.isObject(step)) {
          params = step;
          step = null;
        }
        showPurchaseWizard = function(user, done) {
          return App.views.main.setPageView(new App.Views.PurchaseWizard({
            user: user,
            itemspot: itemspot,
            step: step,
            params: params,
            done: done
          }));
        };
        purchaseWizardCompleted = function() {
          return App.router.navigate("" + (itemspot.getRouterUrl()) + "/thanks", {
            trigger: true
          });
        };
        showNewUserPurchaseWizard = function(user) {
          var addresses;
          addresses = user.getAddresses();
          return addresses.fetch({
            success: function() {
              return showPurchaseWizard(user, function() {
                return purchaseWizardCompleted();
              });
            }
          });
        };
        fetchUserAndShowPurchaseWizard = function(user) {
          var success;
          success = function(user) {
            return showPurchaseWizard(user, function() {
              return purchaseWizardCompleted();
            });
          };
          if (App.config.offlineMode) {
            return success(user);
          }
          return user.fetch({
            success: success
          });
        };
        user = App.auth.user;
        if (user.isLoggedIn()) {
          return fetchUserAndShowPurchaseWizard(user);
        }
        return showNewUserPurchaseWizard(user);
      });
    };

    Router.prototype.thanks = function(boutiqueCode, index) {
      console.debug('Routing to thanks.');
      return getItemSpotOrShowNotFound(boutiqueCode, index, function(itemspot) {
        return App.views.main.setPageView(new App.Views.Thanks({
          itemspot: itemspot
        }));
      });
    };

    Router.prototype.boutiqueNotFound = function(code) {
      return console.log("Boutique '" + code + "' was not found.");
    };

    Router.prototype.itemspotNotFound = function(boutiqueCode, index) {
      return console.log("ItemSpot #" + index + " of boutique " + boutiqueCode + " was not found.");
    };

    Router.prototype.routeNotFound = function(route) {
      if (route.slice(-1) === '/') {
        console.error("Requested route '" + route + "' has a trailing slash. Redirecting.");
        return this.navigate(route.slice(0, -1), {
          trigger: true,
          replace: true
        });
      }
      return console.debug("Route '" + route + "' not found.");
    };

    return Router;

  })(Backbone.Router);

  getBoutiqueOrShowNotFound = function(boutiqueCode, success) {
    return App.collections.boutiques.getOrFetch(boutiqueCode, {
      success: success,
      notFound: function() {
        return App.router.navigate("/boutiques/" + boutiqueCode + "/notFound", {
          trigger: true,
          replace: true
        });
      }
    });
  };

  getItemSpotOrShowNotFound = function(boutiqueCode, index, success) {
    return getBoutiqueOrShowNotFound(boutiqueCode, function(boutique) {
      var itemspot;
      if (itemspot = boutique.getItemSpotFromIndex(index)) {
        return success(itemspot);
      }
      return App.router.navigate("/boutiques/" + boutiqueCode + "/items/" + index + "/notFound", {
        trigger: true,
        replace: true
      });
    });
  };

}).call(this);
