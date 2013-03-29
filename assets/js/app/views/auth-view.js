(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.PasswordWidget = (function(_super) {

    __extends(PasswordWidget, _super);

    function PasswordWidget() {
      return PasswordWidget.__super__.constructor.apply(this, arguments);
    }

    PasswordWidget.prototype.template = 'password-widget';

    PasswordWidget.prototype.events = {
      'click #toggle-password-display-checkbox': 'togglePasswordDisplay'
    };

    PasswordWidget.prototype.initialize = function(options) {
      return this.placeholderText = options.placeholderText || 'Password';
    };

    PasswordWidget.prototype.togglePasswordDisplay = function() {
      var $passwordFields;
      $passwordFields = this.$('input.password');
      $passwordFields.val($passwordFields.not('.hidden').val());
      return $passwordFields.toggleClass('hidden');
    };

    PasswordWidget.prototype.serialize = function() {
      return {
        placeholderText: this.placeholderText
      };
    };

    return PasswordWidget;

  })(App.Views.FormView);

  App.Views.Auth = (function(_super) {

    __extends(Auth, _super);

    function Auth() {
      return Auth.__super__.constructor.apply(this, arguments);
    }

    Auth.prototype.template = 'auth-login';

    Auth.prototype.className = 'auth-view auth-login-view';

    Auth.prototype.events = {
      'click #login-button': 'submitButtonClicked',
      'keydown input': 'performValidation'
    };

    Auth.prototype.fields = {
      'email': '#user-email',
      'password': '#user-password'
    };

    Auth.prototype.initialize = function(options) {
      console.log('Initializing auth view.');
      this.callbacks = options.callbacks || {};
      this.setView('.password-widget', new App.Views.PasswordWidget());
      return this.performValidation();
    };

    Auth.prototype.submitButtonClicked = function(event) {
      var _this = this;
      event.preventDefault();
      return this.validateForm({
        error: function(message) {
          return this.errorAlert(message);
        },
        success: function(email, password) {
          return _this.login(email, password);
        }
      });
    };

    Auth.prototype.performValidation = function() {
      var _this = this;
      return _.defer(function() {
        var $button;
        $button = _this.$('button');
        return _this.validateForm({
          error: function(message) {
            $button.text(message);
            return $button.attr('disabled', true);
          },
          success: function(cleanedFields) {
            $button.text('Login');
            return $button.removeAttr('disabled');
          }
        });
      });
    };

    Auth.prototype.validateForm = function(callbacks) {
      var email, password;
      email = this.getFieldValue('email');
      password = this.getFieldValue('password');
      if (!email || !password) {
        return typeof callbacks.error === "function" ? callbacks.error('Fill in all fields') : void 0;
      }
      return typeof callbacks.success === "function" ? callbacks.success(email, password) : void 0;
    };

    Auth.prototype.login = function(email, password) {
      var _this = this;
      return App.auth.login(email, password, {
        success: function(user) {
          var _base;
          return typeof (_base = _this.callbacks).success === "function" ? _base.success(user) : void 0;
        },
        incorrect: function() {
          var _base;
          _this.errorAlert("You've supplied invalid credentials. Try again :)");
          return typeof (_base = _this.callbacks.incorrect || _this.callbacks.error) === "function" ? _base() : void 0;
        },
        disabled: function() {
          var _base;
          _this.errorAlert("That account has been disabled. Sorry!");
          return typeof (_base = _this.callbacks.disabled || _this.callbacks.error) === "function" ? _base() : void 0;
        },
        error: function() {
          var _base;
          _this.errorAlert("Something went wrong with the login request. Try again :)");
          console.error("Unhandled error during login request.");
          console.error(arguments);
          return typeof (_base = _this.callbacks).error === "function" ? _base.error() : void 0;
        }
      });
    };

    Auth.prototype.serialize = function() {
      return {
        buttonText: 'Login',
        instructions: 'Enter your login info below :)',
        user: App.auth.user.toJSON()
      };
    };

    return Auth;

  })(App.Views.FormView);

  App.Views.Registration = (function(_super) {

    __extends(Registration, _super);

    function Registration() {
      return Registration.__super__.constructor.apply(this, arguments);
    }

    Registration.prototype.template = 'auth-register';

    Registration.prototype.className = 'auth-view auth-register-view';

    Registration.prototype.events = {
      'click  #register-button': 'submitButtonClicked',
      'keydown input': 'performValidation'
    };

    Registration.prototype.fields = {
      'email': '#user-email',
      'password': '#user-password'
    };

    Registration.prototype.initialize = function(options) {
      console.log('Initializing registration view.');
      this.callbacks = options.callbacks || {};
      this.initializePasswordWidget();
      return this.performValidation();
    };

    Registration.prototype.initializePasswordWidget = function() {
      var passwordWidget;
      passwordWidget = new App.Views.PasswordWidget({
        placeholderText: 'Password (optional)'
      });
      return this.setView('.password-widget', passwordWidget);
    };

    Registration.prototype.submitButtonClicked = function(event) {
      var _this = this;
      event.preventDefault();
      return this.validateForm({
        error: function(message) {
          return this.errorAlert(message);
        },
        success: function(email, password) {
          if (!password) {
            return _this.skipped(email);
          }
          return _this.register(email, password);
        }
      });
    };

    Registration.prototype.performValidation = function() {
      var _this = this;
      return _.defer(function() {
        var $button;
        $button = _this.$('button');
        return _this.validateForm({
          error: function(message) {
            $button.text(message);
            return $button.attr('disabled', true);
          },
          success: function(email, password) {
            var text;
            text = password ? 'Register and Continue' : 'Continue';
            $button.text(text);
            return $button.removeAttr('disabled');
          }
        });
      });
    };

    Registration.prototype.validateForm = function(callbacks) {
      var email, password;
      email = this.getFieldValue('email');
      password = this.getFieldValue('password');
      if (!email) {
        return typeof callbacks.error === "function" ? callbacks.error('Please enter your email') : void 0;
      }
      return typeof callbacks.success === "function" ? callbacks.success(email, password) : void 0;
    };

    Registration.prototype.register = function(email, password) {
      var _this = this;
      return App.auth.register(email, password, {
        success: function(user) {
          var _base;
          return typeof (_base = _this.callbacks).success === "function" ? _base.success(user) : void 0;
        },
        alreadyInUse: function() {
          var _base;
          _this.errorAlert("That email address is already in use.");
          return typeof (_base = _this.callbacks.alreadyInUse || _this.callbacks.error) === "function" ? _base(email, password) : void 0;
        },
        invalid: function() {
          var _base;
          _this.errorAlert('The email address you entered is invalid.');
          return typeof (_base = _this.callbacks.invalid || _this.callbacks.error) === "function" ? _base(email, password) : void 0;
        },
        error: function() {
          var _base;
          _this.errorAlert('Something went wrong with the registration request. Try again :)');
          console.error("Unhandled error during registration request:\n" + arguments);
          return typeof (_base = _this.callbacks).error === "function" ? _base.error(email, password) : void 0;
        }
      });
    };

    Registration.prototype.skipped = function(email) {
      var _base;
      App.auth.user.set('email', email);
      return typeof (_base = this.callbacks).skipped === "function" ? _base.skipped(email) : void 0;
    };

    Registration.prototype.serialize = function() {
      var rand;
      rand = App.utils.getRandomInteger(0, 1000000);
      return {
        email: "hugeackman_" + rand + "@jointrolley.com"
      };
    };

    return Registration;

  })(App.Views.FormView);

  App.Views.LoginOrNewUser = (function(_super) {

    __extends(LoginOrNewUser, _super);

    function LoginOrNewUser() {
      return LoginOrNewUser.__super__.constructor.apply(this, arguments);
    }

    LoginOrNewUser.prototype.template = 'login-or-new-user';

    LoginOrNewUser.prototype.className = 'login-or-new-user-view';

    return LoginOrNewUser;

  })(Backbone.LayoutView);

  App.Views.LoginOrNewUserPopup = (function(_super) {

    __extends(LoginOrNewUserPopup, _super);

    function LoginOrNewUserPopup() {
      return LoginOrNewUserPopup.__super__.constructor.apply(this, arguments);
    }

    LoginOrNewUserPopup.prototype.events = _.extend({}, App.Views.Popup.prototype.events, {
      'click #new-user-button': 'newUserButtonClicked',
      'click #existing-user-button': 'loginButtonClicked'
    });

    LoginOrNewUserPopup.prototype.title = 'Before we begin, are you a...';

    LoginOrNewUserPopup.prototype.initialize = function(options) {
      LoginOrNewUserPopup.__super__.initialize.apply(this, arguments);
      return this.setContents(new App.Views.LoginOrNewUser({
        model: options.model
      }));
    };

    LoginOrNewUserPopup.prototype.newUserButtonClicked = function() {
      var _base;
      console.debug("New user button clicked.");
      return typeof (_base = this.callbacks).newUserSuccess === "function" ? _base.newUserSuccess(this.model) : void 0;
    };

    LoginOrNewUserPopup.prototype.loginButtonClicked = function() {
      console.debug("Login button clicked.");
      this.setLoginView();
      return this.render();
    };

    LoginOrNewUserPopup.prototype.setLoginView = function() {
      var callbacks,
        _this = this;
      this.setTitle('Welcome back!');
      callbacks = _.extend(this.callbacks, {
        success: function(user) {
          var _base;
          return typeof (_base = _this.callbacks).loginSuccess === "function" ? _base.loginSuccess(user) : void 0;
        }
      });
      return this.setContents(new App.Views.Auth({
        model: this.model,
        callbacks: callbacks
      }));
    };

    return LoginOrNewUserPopup;

  })(App.Views.Popup);

  App.Views.LoginPopup = (function(_super) {

    __extends(LoginPopup, _super);

    function LoginPopup() {
      return LoginPopup.__super__.constructor.apply(this, arguments);
    }

    LoginPopup.prototype.title = 'Welcome back!';

    LoginPopup.prototype.initialize = function(options) {
      LoginPopup.__super__.initialize.apply(this, arguments);
      return this.setContents(new App.Views.Auth(options));
    };

    return LoginPopup;

  })(App.Views.Popup);

  App.Views.RegistrationPopup = (function(_super) {

    __extends(RegistrationPopup, _super);

    function RegistrationPopup() {
      return RegistrationPopup.__super__.constructor.apply(this, arguments);
    }

    RegistrationPopup.prototype.title = 'Oh! One last thing...';

    RegistrationPopup.prototype.initialize = function(options) {
      RegistrationPopup.__super__.initialize.apply(this, arguments);
      return this.setContents(new App.Views.Registration(options));
    };

    return RegistrationPopup;

  })(App.Views.Popup);

}).call(this);
