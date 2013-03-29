(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Models.User = (function(_super) {

    __extends(User, _super);

    function User() {
      return User.__super__.constructor.apply(this, arguments);
    }

    User.prototype.relations = [
      {
        type: Backbone.HasOne,
        key: 'account',
        relatedModel: 'App.Models.Account',
        reverseRelation: {
          type: Backbone.HasOne,
          key: 'user'
        }
      }
    ];

    User.prototype.initialize = function(options) {
      console.debug('Initializing user model.');
      return this.set('account', new App.Models.Account());
    };

    User.prototype.getAddresses = function() {
      return (this.get('account')).get('addresses');
    };

    User.prototype.login = function(email, password, callbacks) {
      if (callbacks == null) {
        callbacks = {};
      }
      return App.auth.login(email, password, callbacks);
    };

    User.prototype.isLoggedIn = function() {
      return App.auth.isLoggedIn;
    };

    User.prototype.url = function() {
      return "" + App.config.urls.api + "/users/";
    };

    return User;

  })(Backbone.RelationalModel);

  App.Models.User.setup();

}).call(this);
