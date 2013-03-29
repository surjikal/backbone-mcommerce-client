(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.Confirm = (function(_super) {

    __extends(Confirm, _super);

    function Confirm() {
      return Confirm.__super__.constructor.apply(this, arguments);
    }

    Confirm.prototype.template = 'confirm';

    Confirm.prototype.className = 'content confirm-view';

    Confirm.prototype.dependencies = ['address'];

    Confirm.prototype.initialize = function(options) {
      Confirm.__super__.initialize.apply(this, arguments);
      console.debug('Initializing confirm wizard step.');
      this.itemspot = options.itemspot;
      this.address = options.wizardData.address;
      return this.setView('.order-table', new App.Views.OrderTable({
        itemspot: this.itemspot
      }));
    };

    Confirm.prototype.beforeNextStep = function(done) {
      return done();
    };

    Confirm.prototype.serialize = function() {
      console.debug("Serializing confirm view.");
      return {
        item: this.serializeItem()
      };
    };

    Confirm.prototype.serializeItem = function() {
      var itemspot;
      itemspot = this.itemspot.toViewJSON();
      return {
        name: itemspot.item.name,
        price: itemspot.itemPrice
      };
    };

    return Confirm;

  })(App.Views.WizardStep);

}).call(this);
