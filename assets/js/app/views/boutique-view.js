(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.Boutique = (function(_super) {

    __extends(Boutique, _super);

    function Boutique() {
      return Boutique.__super__.constructor.apply(this, arguments);
    }

    Boutique.prototype.template = 'boutique';

    Boutique.prototype.className = 'content boutique-view';

    Boutique.prototype.serialize = function() {
      var serializedItemSpots;
      serializedItemSpots = this.serializeItemSpotModels();
      return {
        name: this.model.get('code'),
        itemSpotRow: [
          {
            itemSpots: serializedItemSpots.slice(0, 2)
          }, {
            itemSpots: serializedItemSpots.slice(2, 4)
          }, {
            itemSpots: serializedItemSpots.slice(4, 6)
          }, {
            itemSpots: serializedItemSpots.slice(6, 8)
          }
        ]
      };
    };

    Boutique.prototype.serializeItemSpotModels = function() {
      var itemSpots,
        _this = this;
      itemSpots = this.model.get('itemSpots');
      itemSpots.sort();
      return itemSpots = itemSpots.map(function(itemSpot) {
        return itemSpot.toViewJSON();
      });
    };

    return Boutique;

  })(Backbone.LayoutView);

}).call(this);
