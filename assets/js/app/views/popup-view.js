(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.Popup = (function(_super) {

    __extends(Popup, _super);

    function Popup() {
      return Popup.__super__.constructor.apply(this, arguments);
    }

    Popup.prototype.template = 'popup';

    Popup.prototype.className = 'popup-view';

    Popup.prototype.events = {
      'click .close, .dim-overlay': 'close'
    };

    Popup.prototype.initialize = function(options) {
      this.title = this.title || options.title;
      this.instructions = this.instructions || options.instructions;
      this.callbacks = options.callbacks;
      return this.initializeContents(options);
    };

    Popup.prototype.initializeContents = function(options) {
      var contents;
      contents = this.contents || options.contents;
      contents = typeof contents === "function" ? contents(options) : void 0;
      if (contents) {
        return this.setContents(contents);
      }
    };

    Popup.prototype.close = function() {
      var _base;
      this._close();
      return typeof (_base = this.callbacks).closed === "function" ? _base.closed() : void 0;
    };

    Popup.prototype.setTitle = function(title) {
      this.title = title;
    };

    Popup.prototype.setInstructions = function(instructions) {
      this.instructions = instructions;
    };

    Popup.prototype.setContents = function(contents) {
      this.contents = contents;
      return this.setView('.contents', this.contents);
    };

    Popup.prototype.serialize = function() {
      return {
        title: this.title,
        instructions: this.instructions
      };
    };

    Popup.prototype._close = function() {
      return App.views.main.removePopup();
    };

    return Popup;

  })(Backbone.LayoutView);

}).call(this);
