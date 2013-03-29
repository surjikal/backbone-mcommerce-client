(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Collections.Base = (function(_super) {

    __extends(Base, _super);

    function Base() {
      return Base.__super__.constructor.apply(this, arguments);
    }

    Base.prototype.getOrFetch = function(modelId, _arg) {
      var model, notFound, success,
        _this = this;
      success = _arg.success, notFound = _arg.notFound;
      if ((model = this.get(modelId))) {
        return success(model);
      }
      model = new this.model;
      model.set(model.idAttribute, modelId);
      return model.fetch({
        error: function() {
          return notFound(modelId);
        },
        success: function() {
          _this.push(model);
          return success(model);
        }
      });
    };

    return Base;

  })(Backbone.Collection);

}).call(this);
