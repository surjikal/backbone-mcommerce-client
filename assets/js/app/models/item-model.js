(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Models.Item = (function(_super) {

    __extends(Item, _super);

    function Item() {
      return Item.__super__.constructor.apply(this, arguments);
    }

    Item.prototype.defaults = {
      itemPrice: 0,
      resourceUri: ''
    };

    Item.prototype.relations = [
      {
        type: Backbone.HasOne,
        key: 'item',
        relatedModel: 'App.Models.Item',
        collectionType: 'App.Collections.Item'
      }
    ];

    Item.prototype.url = function() {
      var boutiqueCode, index;
      boutiqueCode = this.get('boutiqueCode');
      index = this.get('index');
      return "/boutiques/" + boutiqueCode + "/item/" + index + "/";
    };

    return Item;

  })(Backbone.RelationalModel);

}).call(this);
