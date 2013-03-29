(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Models.ItemSpot = (function(_super) {

    __extends(ItemSpot, _super);

    function ItemSpot() {
      return ItemSpot.__super__.constructor.apply(this, arguments);
    }

    ItemSpot.prototype.getBoutiqueCode = function() {
      var boutique;
      boutique = this.get('boutique');
      return boutique.get('code');
    };

    ItemSpot.prototype.getCheckoutUrl = function() {
      return "" + (this.getRouterUrl()) + "/checkout";
    };

    ItemSpot.prototype.getRouterUrl = function() {
      var code, index;
      index = this.get('index');
      code = this.getBoutiqueCode();
      return "boutiques/" + code + "/items/" + index;
    };

    ItemSpot.prototype.getImageUrl = function() {
      var item;
      item = this.get('item');
      if (App.config.offlineMode) {
        return item.image;
      }
      return "" + App.config.urls["static"] + "/images/" + item.image;
    };

    ItemSpot.prototype.getStats = function() {
      var likes, views;
      views = App.utils.getRandomInteger(0, 10000);
      likes = App.utils.getRandomInteger(0, views);
      return {
        views: views,
        likes: likes
      };
    };

    ItemSpot.prototype.toViewJSON = function(boutiqueCode) {
      return _.extend(this.toJSON(), {
        image: this.getImageUrl(),
        url: this.getRouterUrl(),
        stats: this.getStats()
      });
    };

    ItemSpot.prototype.url = function() {
      var code, index;
      index = this.get('index');
      code = this.getBoutiqueCode();
      return "" + App.config.urls.api + "/boutiques/" + code + "/itemspots/" + index;
    };

    return ItemSpot;

  })(Backbone.RelationalModel);

}).call(this);
