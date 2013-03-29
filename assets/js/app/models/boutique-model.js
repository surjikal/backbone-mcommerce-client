(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Models.Boutique = (function(_super) {

    __extends(Boutique, _super);

    function Boutique() {
      return Boutique.__super__.constructor.apply(this, arguments);
    }

    Boutique.prototype.idAttribute = 'code';

    Boutique.prototype.defaults = {
      code: null
    };

    Boutique.prototype.relations = [
      {
        type: Backbone.HasMany,
        key: 'itemSpots',
        relatedModel: 'App.Models.ItemSpot',
        collectionType: 'App.Collections.ItemSpot',
        reverseRelation: {
          key: 'boutique',
          includeInJSON: 'code'
        }
      }
    ];

    Boutique.prototype.getItemSpotFromIndex = function(index) {
      var itemSpots;
      itemSpots = this.get('itemSpots');
      itemSpots.sort();
      return itemSpots.at(index - 1);
    };

    Boutique.prototype.getRouterUrl = function() {
      return "/boutiques/" + this.id;
    };

    Boutique.prototype.urlRoot = function() {
      return "" + App.config.urls.api + "/boutiques";
    };

    return Boutique;

  })(Backbone.RelationalModel);

  App.Models.Boutique.setup();

}).call(this);
