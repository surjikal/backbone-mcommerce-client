(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.ItemSpot = (function(_super) {

    __extends(ItemSpot, _super);

    function ItemSpot() {
      this.navigateToCheckout = __bind(this.navigateToCheckout, this);
      return ItemSpot.__super__.constructor.apply(this, arguments);
    }

    ItemSpot.prototype.template = 'itemspot';

    ItemSpot.prototype.className = 'itemspot-view';

    ItemSpot.prototype.events = {
      'click #buy-button': 'navigateToCheckout'
    };

    ItemSpot.prototype.initialize = function() {
      var _this = this;
      return $(window).on('resize', _.debounce(function() {
        return _this.onResize();
      }, 10));
    };

    ItemSpot.prototype.navigateToCheckout = function(event) {
      var _this = this;
      return (this.withLoadingSpinner(event))({
        target: '#buy-button',
        onEvent: function(loader) {
          loader.start();
          return App.router.navigate(_this.model.getCheckoutUrl(), {
            trigger: true
          });
        }
      });
    };

    ItemSpot.prototype.serialize = function() {
      return this.model.toViewJSON();
    };

    ItemSpot.prototype.afterRender = function() {
      var $img,
        _this = this;
      $img = this.$('.item-images img');
      return $img.on('load', function() {
        return _this._adjustLayout();
      });
    };

    ItemSpot.prototype.onResize = function() {
      return this._adjustLayout();
    };

    ItemSpot.prototype._adjustLayout = function() {
      var _adjustItemDetailsLayout, _adjustItemInfoLayout;
      (_adjustItemInfoLayout = function() {
        var $itemImages, $itemInfo;
        $itemInfo = this.$('.item-info');
        $itemImages = this.$('.item-images');
        return $itemInfo.css('top', $itemImages.height());
      })();
      return (_adjustItemDetailsLayout = function() {
        var $header, $itemDetails;
        $itemDetails = this.$('.item-info .item-details');
        $header = this.$('.item-info header');
        return $itemDetails.css('top', $header.height());
      })();
    };

    return ItemSpot;

  })(App.Views.FormView);

}).call(this);
