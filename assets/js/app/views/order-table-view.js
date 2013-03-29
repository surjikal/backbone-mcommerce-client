(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.OrderTable = (function(_super) {

    __extends(OrderTable, _super);

    function OrderTable() {
      return OrderTable.__super__.constructor.apply(this, arguments);
    }

    OrderTable.prototype.template = 'order-table';

    OrderTable.prototype.className = 'order-table-view';

    OrderTable.prototype.initialize = function(options) {
      return this.itemspot = options.itemspot, options;
    };

    OrderTable.prototype.getCosts = function() {
      var item, tax, total;
      item = parseFloat(this.itemspot.get('itemPrice'));
      tax = item * 0.13;
      total = tax + item;
      return {
        item: item,
        tax: tax,
        total: total,
        shipping: 'free!'
      };
    };

    OrderTable.prototype.serialize = function() {
      return {
        costs: this.getCosts(),
        item: this.itemspot.toViewJSON().item
      };
    };

    return OrderTable;

  })(Backbone.LayoutView);

}).call(this);
