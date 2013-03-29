(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Models.Address = (function(_super) {

    __extends(Address, _super);

    function Address() {
      return Address.__super__.constructor.apply(this, arguments);
    }

    Address.prototype.defaults = {
      firstName: null,
      lastName: null,
      street: null,
      postalCode: null
    };

    Address.prototype.urlRoot = function() {
      return "" + App.config.urls.api + "/addresses/";
    };

    return Address;

  })(Backbone.RelationalModel);

  App.Models.Address.setup();

}).call(this);
