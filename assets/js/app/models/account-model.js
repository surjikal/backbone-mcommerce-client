(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Models.Account = (function(_super) {

    __extends(Account, _super);

    function Account() {
      return Account.__super__.constructor.apply(this, arguments);
    }

    Account.prototype.defaults = {
      firstName: null,
      lastName: null,
      addresses: null
    };

    Account.prototype.relations = [
      {
        type: Backbone.HasMany,
        key: 'addresses',
        relatedModel: 'App.Models.Address'
      }
    ];

    Account.prototype.initialize = function(options) {
      console.debug('Initializing account model.');
      return this.addresses = new App.Collections.Address();
    };

    Account.prototype.isLoggedIn = function() {
      return App.auth.isLoggedIn;
    };

    return Account;

  })(Backbone.RelationalModel);

  App.Models.Account.setup();

}).call(this);
