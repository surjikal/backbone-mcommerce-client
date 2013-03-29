(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.AddressModeView = (function(_super) {

    __extends(AddressModeView, _super);

    function AddressModeView() {
      return AddressModeView.__super__.constructor.apply(this, arguments);
    }

    AddressModeView.prototype.validateForm = function() {
      console.warn("AddressModeView#validateForm not implemented.");
      return {};
    };

    AddressModeView.prototype.submitForm = function(cleanedFields) {
      return console.warn("AddressModeView#submitForm not implemented.");
    };

    return AddressModeView;

  })(App.Views.FormView);

}).call(this);
