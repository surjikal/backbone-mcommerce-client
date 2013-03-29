(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.Main = (function(_super) {

    __extends(Main, _super);

    function Main() {
      this.showLoginPopup = __bind(this.showLoginPopup, this);
      return Main.__super__.constructor.apply(this, arguments);
    }

    Main.prototype.el = 'body';

    Main.prototype.showLoginPopup = function() {
      return this.showPopup(new App.Views.LoginOrNewUserPopup());
    };

    Main.prototype.showPopup = function(popup) {
      this.popup = popup;
      this.setView('#popup', this.popup);
      return this.popup.render();
    };

    Main.prototype.removePopup = function() {
      var _ref;
      if ((_ref = this.popup) != null) {
        _ref.remove();
      }
      return this.popup = null;
    };

    Main.prototype.setPageView = function(page, removeHeader) {
      if (removeHeader == null) {
        removeHeader = false;
      }
      if (page.className === 'boutique-select-view') {
        this.$('#page').addClass('no-border');
      } else {
        this.$('#page').removeClass('no-border');
      }
      if (removeHeader) {
        this.removeHeader();
      } else {
        this.attachHeader();
      }
      this.setView('#page', page);
      return page.render();
    };

    Main.prototype.attachHeader = function() {
      if (this.header) {
        return;
      }
      this.header = new App.Views.Header();
      this.setView('#header', this.header);
      return this.header.render();
    };

    Main.prototype.removeHeader = function() {
      var _ref;
      if ((_ref = this.header) != null) {
        _ref.remove();
      }
      return this.header = null;
    };

    return Main;

  })(Backbone.LayoutView);

}).call(this);
