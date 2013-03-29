(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.AuthWizardStatusBar = (function(_super) {

    __extends(AuthWizardStatusBar, _super);

    function AuthWizardStatusBar() {
      return AuthWizardStatusBar.__super__.constructor.apply(this, arguments);
    }

    AuthWizardStatusBar.prototype.template = 'wizard-step-status-bar-auth';

    AuthWizardStatusBar.prototype.className = 'wizard-step-status-bar-auth-view';

    AuthWizardStatusBar.prototype.serialize = function() {
      if (App.auth.user.isLoggedIn()) {
        return {
          user: App.auth.user.toJSON()
        };
      }
    };

    return AuthWizardStatusBar;

  })(Backbone.LayoutView);

  App.Views.OrderWizardStatusBar = (function(_super) {

    __extends(OrderWizardStatusBar, _super);

    function OrderWizardStatusBar() {
      return OrderWizardStatusBar.__super__.constructor.apply(this, arguments);
    }

    OrderWizardStatusBar.prototype.template = 'wizard-step-status-bar-order';

    OrderWizardStatusBar.prototype.className = 'wizard-step-status-bar-order-view';

    OrderWizardStatusBar.prototype.initialize = function(_arg) {
      var itemspot;
      itemspot = _arg.itemspot;
      return this.setView('.order-table', new App.Views.OrderTable({
        itemspot: itemspot
      }));
    };

    return OrderWizardStatusBar;

  })(Backbone.LayoutView);

}).call(this);
