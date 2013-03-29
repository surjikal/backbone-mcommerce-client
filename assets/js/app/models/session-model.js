(function() {
  var AuthPersistenceBackend,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  AuthPersistenceBackend = (function() {

    function AuthPersistenceBackend() {}

    AuthPersistenceBackend.prototype.set = function(username, password) {
      localStorage.setItem('email', email);
      localStorage.setItem('password', password);
      return Backbone.BasicAuth.set(email, password);
    };

    AuthPersistenceBackend.prototype.get = function() {
      return {
        email: localStorage.getItem('email'),
        password: localStorage.getItem('password')
      };
    };

    AuthPersistenceBackend.prototype.clear = function() {
      localStorage.removeItem('email');
      localStorage.removeItem('password');
      return Backbone.BasicAuth.clear();
    };

    return AuthPersistenceBackend;

  })();

  App.Models.Session = (function(_super) {

    __extends(Session, _super);

    function Session() {
      return Session.__super__.constructor.apply(this, arguments);
    }

    Session.prototype.defaults = {
      email: null,
      password: null
    };

    Session.prototype.isAuthenticated = false;

    Session.prototype.initialize = function() {
      this.backend = new AuthPersistenceBackend();
      return this.load();
    };

    Session.prototype.save = function(email, password) {
      this.backend.set(username, password);
      return this.isAuthenticated = true;
    };

    Session.prototype.load = function() {
      return this.set(this.backend.get());
    };

    Session.prototype.clear = function() {
      this.backend.clear();
      return Session.__super__.clear.apply(this, arguments);
    };

    return Session;

  })(Backbone.Model);

}).call(this);
