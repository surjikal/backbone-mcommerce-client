(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Collections.ItemSpot = (function(_super) {

    __extends(ItemSpot, _super);

    function ItemSpot() {
      return ItemSpot.__super__.constructor.apply(this, arguments);
    }

    ItemSpot.prototype.model = App.Models.ItemSpot;

    ItemSpot.prototype.comparator = function(itemspot) {
      return itemspot.get('index');
    };

    return ItemSpot;

  })(App.Collections.Base);

}).call(this);
