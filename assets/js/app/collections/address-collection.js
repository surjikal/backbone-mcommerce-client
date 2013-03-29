(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Collections.Address = (function(_super) {

    __extends(Address, _super);

    function Address() {
      this.onLogout = __bind(this.onLogout, this);
      return Address.__super__.constructor.apply(this, arguments);
    }

    Address.prototype.model = App.Models.Address;

    Address.prototype.initialize = function() {
      console.debug('Initializing address collection.');
      return App.auth.events.on('logout', this.onLogout, this);
    };

    Address.prototype.onLogout = function() {
      this.reset();
      return App.auth.events.off(null, null, this);
    };

    Address.prototype.parse = function(response) {
      return response.objects;
    };

    Address.prototype.url = function() {
      return "" + App.config.urls.api + "/addresses/";
    };

    return Address;

  })(App.Collections.Base);

}).call(this);
