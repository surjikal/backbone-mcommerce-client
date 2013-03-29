(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.Thanks = (function(_super) {

    __extends(Thanks, _super);

    function Thanks() {
      return Thanks.__super__.constructor.apply(this, arguments);
    }

    Thanks.prototype.template = 'thanks';

    Thanks.prototype.className = 'content thanks-view';

    Thanks.prototype.events = {
      'click #back-to-boutique': 'backToBoutiqueButtonClicked'
    };

    Thanks.prototype.initialize = function(options) {
      return this.itemspot = options.itemspot, options;
    };

    Thanks.prototype.backToBoutiqueButtonClicked = function() {
      var boutique;
      boutique = this.itemspot.get('boutique');
      return App.router.navigate(boutique.getRouterUrl(), {
        trigger: true
      });
    };

    Thanks.prototype.serialize = function() {
      return {
        itemspot: this.itemspot.toViewJSON()
      };
    };

    return Thanks;

  })(Backbone.LayoutView);

}).call(this);
