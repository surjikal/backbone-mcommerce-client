(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Collections.Boutique = (function(_super) {

    __extends(Boutique, _super);

    function Boutique() {
      return Boutique.__super__.constructor.apply(this, arguments);
    }

    Boutique.prototype.model = App.Models.Boutique;

    return Boutique;

  })(App.Collections.Base);

}).call(this);
