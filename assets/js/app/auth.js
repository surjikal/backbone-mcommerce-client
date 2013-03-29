(function() {

  App.Auth = (function() {

    Auth.prototype.isLoggedIn = false;

    function Auth() {
      this.events = _.extend({}, Backbone.Events);
      this.credentialStore = new App.Controllers.LocalStorageCredentialStore();
    }

    Auth.prototype.initialize = function() {
      return this._initializeUser();
    };

    Auth.prototype.login = function(email, password, _arg) {
      var disabled, error, incorrect, invalid, success, _ref,
        _this = this;
      _ref = _arg != null ? _arg : {}, success = _ref.success, incorrect = _ref.incorrect, invalid = _ref.invalid, disabled = _ref.disabled, error = _ref.error;
      console.debug(App.api.auth);
      return App.api.auth.validate(email, password, {
        incorrect: incorrect,
        invalid: invalid,
        disabled: disabled,
        error: error,
        success: function() {
          _this._resetUser();
          _this._login(email, password);
          return typeof success === "function" ? success(_this.user) : void 0;
        }
      });
    };

    Auth.prototype.register = function(email, password, _arg) {
      var alreadyInUse, conversionError, error, invalid, success, _ref,
        _this = this;
      _ref = _arg != null ? _arg : {}, success = _ref.success, invalid = _ref.invalid, alreadyInUse = _ref.alreadyInUse, conversionError = _ref.conversionError, error = _ref.error;
      return App.api.auth.register(email, password, {
        invalid: invalid,
        alreadyInUse: alreadyInUse,
        error: error,
        success: function() {
          console.debug("User '" + email + "' was registered successfully");
          _this._login(email, password);
          return _this._convertAnonymousUser({
            error: conversionError,
            success: function() {
              console.debug("Converted anonymous user successfully.");
              _this.credentialStore.save(email, password);
              return typeof success === "function" ? success(_this.user) : void 0;
            }
          });
        }
      });
    };

    Auth.prototype.logout = function() {
      console.debug("Logging out user.");
      this._resetUser();
      this._initializeAnonymousUser();
      this.isLoggedIn = false;
      this.token = null;
      return this.events.trigger('logout');
    };

    Auth.prototype._login = function(email, password) {
      console.debug("Logging in user '" + email + "'.");
      this.token = this._makeBasicAuthToken(email, password);
      Backbone.BasicAuth.set(email, password);
      this.credentialStore.save(email, password);
      this.isLoggedIn = true;
      this.user.set('email', email);
      return this.events.trigger('login');
    };

    Auth.prototype._initializeUser = function() {
      var email, password, _ref;
      this.user = new App.Models.User();
      _ref = this.credentialStore.load(), email = _ref.email, password = _ref.password;
      if (!email || !password) {
        return this._initializeAnonymousUser();
      }
      return this._initializeRegisteredUser(email, password);
    };

    Auth.prototype._initializeRegisteredUser = function(email, password) {
      console.debug("Initializing registered user '" + email + "'.");
      return this._login(email, password);
    };

    Auth.prototype._initializeAnonymousUser = function(email) {
      var addresses;
      console.debug("Initializing anonymous user.");
      if (email) {
        this.user.set('email', email);
      }
      addresses = this.user.getAddresses();
      return addresses.localStorage = new Backbone.LocalStorage('AddressCollection');
    };

    Auth.prototype._convertAnonymousUser = function(_arg) {
      var addresses, addressesCopy, error, makeAddressCreateCallback, serializeAddress, success, _ref;
      _ref = _arg != null ? _arg : {}, success = _ref.success, error = _ref.error;
      addresses = this.user.getAddresses();
      addressesCopy = new App.Collections.Address();
      (this.user.get('account')).set('addresses', addressesCopy);
      serializeAddress = function(address) {
        var serialized;
        serialized = address.toJSON();
        delete serialized.id;
        return serialized;
      };
      if (App.config.offlineMode) {
        addresses.each(function(address) {
          var serialized;
          serialized = serializeAddress(address);
          return addressesCopy.add(serialized);
        });
        return typeof success === "function" ? success() : void 0;
      }
      makeAddressCreateCallback = function(address) {
        return function(callback) {
          var serialized;
          serialized = serializeAddress(address);
          return addressesCopy.create(serialized, {
            error: function(model, error) {
              return callback(error);
            },
            success: function(model) {
              return callback(null, model);
            }
          });
        };
      };
      return async.parallel(addresses.map(makeAddressCreateCallback), function(err, results) {
        if (err) {
          return typeof error === "function" ? error(err) : void 0;
        }
        return typeof success === "function" ? success() : void 0;
      });
    };

    Auth.prototype._resetUser = function() {
      this.user.clear();
      this._resetPersistedData();
      return this.user = new App.Models.User();
    };

    Auth.prototype._resetPersistedData = function() {
      Backbone.BasicAuth.clear();
      this.credentialStore.clear();
      return localStorage.clear();
    };

    Auth.prototype._makeBasicAuthToken = function(username, password) {
      return btoa("" + username + ":" + password);
    };

    return Auth;

  })();

  App.Controllers.LocalStorageCredentialStore = (function() {

    function LocalStorageCredentialStore() {}

    LocalStorageCredentialStore.prototype.save = function(email, password) {
      localStorage.setItem('email', email);
      return localStorage.setItem('password', password);
    };

    LocalStorageCredentialStore.prototype.load = function() {
      return {
        email: localStorage.getItem('email'),
        password: localStorage.getItem('password')
      };
    };

    LocalStorageCredentialStore.prototype.clear = function() {
      localStorage.removeItem('email');
      return localStorage.removeItem('password');
    };

    return LocalStorageCredentialStore;

  })();

}).call(this);
