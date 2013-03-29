(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  App.Views.MenuItem = (function(_super) {

    __extends(MenuItem, _super);

    function MenuItem() {
      return MenuItem.__super__.constructor.apply(this, arguments);
    }

    MenuItem.prototype.template = 'menu-list-item';

    MenuItem.prototype.tagName = 'li';

    MenuItem.prototype.className = 'menu-item';

    MenuItem.prototype.initialize = function(options) {
      return this.title = options.title, this.url = options.url, options;
    };

    MenuItem.prototype.serialize = function() {
      return {
        title: this.title,
        url: this.url
      };
    };

    return MenuItem;

  })(Backbone.LayoutView);

  App.Views.AuthMenuItem = (function(_super) {

    __extends(AuthMenuItem, _super);

    function AuthMenuItem() {
      this.onLogout = __bind(this.onLogout, this);

      this.onLogin = __bind(this.onLogin, this);

      this.logoutClicked = __bind(this.logoutClicked, this);

      this.loginClicked = __bind(this.loginClicked, this);

      this.clicked = __bind(this.clicked, this);
      return AuthMenuItem.__super__.constructor.apply(this, arguments);
    }

    AuthMenuItem.prototype.events = {
      'click': 'clicked'
    };

    AuthMenuItem.prototype.initialize = function() {
      console.debug('Initializing auth menu item.');
      if (App.auth.isLoggedIn) {
        this.setLogoutMode();
      } else {
        this.setLoginMode();
      }
      return this.initEventListeners();
    };

    AuthMenuItem.prototype.initEventListeners = function() {
      App.auth.events.on('login', this.onLogin, this);
      return App.auth.events.on('logout', this.onLogout, this);
    };

    AuthMenuItem.prototype.clicked = function() {
      if (this.mode === 'logout') {
        return this.logoutClicked();
      } else {
        return this.loginClicked();
      }
    };

    AuthMenuItem.prototype.loginClicked = function() {
      var popup,
        _this = this;
      popup = new App.Views.LoginPopup({
        model: App.auth.user,
        callbacks: {
          success: function() {
            return popup.close();
          }
        }
      });
      return App.views.main.showPopup(popup);
    };

    AuthMenuItem.prototype.logoutClicked = function() {
      return App.auth.logout();
    };

    AuthMenuItem.prototype.onLogin = function() {
      this.setLogoutMode();
      return this.render();
    };

    AuthMenuItem.prototype.onLogout = function() {
      this.setLoginMode();
      return this.render();
    };

    AuthMenuItem.prototype.setLoginMode = function() {
      this.mode = 'login';
      this.title = 'Login';
      return this.url = null;
    };

    AuthMenuItem.prototype.setLogoutMode = function() {
      this.mode = 'logout';
      this.title = 'Logout';
      return this.url = null;
    };

    return AuthMenuItem;

  })(App.Views.MenuItem);

  App.Views.Menu = (function(_super) {

    __extends(Menu, _super);

    function Menu() {
      this.close = __bind(this.close, this);

      this.toggleVisibility = __bind(this.toggleVisibility, this);
      return Menu.__super__.constructor.apply(this, arguments);
    }

    Menu.prototype.tagName = 'ul';

    Menu.prototype.className = 'menu-view';

    Menu.prototype.events = {
      'click': 'close'
    };

    Menu.prototype.initialize = function(options) {
      var _this = this;
      this.initializeMenuItems(options.items);
      return App.router.on('all', function() {
        return _.defer(function() {
          return _this.$el.removeClass('active');
        });
      });
    };

    Menu.prototype.initializeMenuItems = function(items) {
      var _this = this;
      if (items == null) {
        items = [];
      }
      return _.each(items, function(item) {
        var ViewClass;
        ViewClass = item.viewClass || App.Views.MenuItem;
        return _this.insertView(new ViewClass(item));
      });
    };

    Menu.prototype.toggleVisibility = function() {
      return this.$el.toggleClass('active');
    };

    Menu.prototype.close = function() {
      return this.$el.removeClass('active');
    };

    return Menu;

  })(Backbone.LayoutView);

  App.Views.Header = (function(_super) {

    __extends(Header, _super);

    function Header() {
      this.leftActionClicked = __bind(this.leftActionClicked, this);

      this.rightActionClicked = __bind(this.rightActionClicked, this);
      return Header.__super__.constructor.apply(this, arguments);
    }

    Header.prototype.template = 'header';

    Header.prototype.className = 'header-view';

    Header.prototype.events = {
      'click .left-action': 'leftActionClicked',
      'click .right-action': 'rightActionClicked'
    };

    Header.prototype.initialize = function() {
      console.debug('Initializing header.');
      return this.setView('.menu', (this.menu = this.createMenu()));
    };

    Header.prototype.createMenu = function() {
      return new App.Views.Menu({
        items: [
          {
            viewClass: App.Views.AuthMenuItem
          }, {
            title: 'Home',
            url: App.config.urls.root
          }
        ]
      });
    };

    Header.prototype.rightActionClicked = function() {
      return this.menu.toggleVisibility();
    };

    Header.prototype.leftActionClicked = function() {
      return window.history.back();
    };

    return Header;

  })(Backbone.LayoutView);

}).call(this);
