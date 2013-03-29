(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.WizardStepListItem = (function(_super) {

    __extends(WizardStepListItem, _super);

    function WizardStepListItem() {
      return WizardStepListItem.__super__.constructor.apply(this, arguments);
    }

    WizardStepListItem.prototype.tagName = 'li';

    WizardStepListItem.prototype.className = 'wizard-step-list-item';

    WizardStepListItem.prototype.template = 'wizard-step-list-item';

    WizardStepListItem.prototype.initialize = function(options) {
      return this.step = options.step;
    };

    WizardStepListItem.prototype.setPercentageWidth = function(width) {
      return this.$el.css('width', "" + width + "%");
    };

    WizardStepListItem.prototype.getIcon = function() {
      if (this.step.state === 'complete') {
        return 'checkmark';
      } else {
        return this.step.icon;
      }
    };

    WizardStepListItem.prototype.beforeRender = function() {
      return this.$el.addClass(this.step.state || '');
    };

    WizardStepListItem.prototype.serialize = function() {
      return {
        index: this.step._index + 1,
        title: this.step.title,
        icon: this.getIcon(),
        completed: this.step.state === 'complete'
      };
    };

    return WizardStepListItem;

  })(Backbone.LayoutView);

  App.Views.WizardStepList = (function(_super) {

    __extends(WizardStepList, _super);

    function WizardStepList() {
      return WizardStepList.__super__.constructor.apply(this, arguments);
    }

    WizardStepList.prototype.tagName = 'ol';

    WizardStepList.prototype.className = 'wizard-steps';

    WizardStepList.prototype.keep = true;

    WizardStepList.prototype.initialize = function(options) {
      var _this = this;
      this.steps = options.steps;
      this.eventDispatcher = options.eventDispatcher;
      this.eventDispatcher.on('step:completed', function() {
        return _this.render();
      }, this);
      return $(window).resize(_.debounce((function() {
        return _this._adjustSeparatorWidth();
      }), 10));
    };

    WizardStepList.prototype.beforeRender = function() {
      var _this = this;
      return _.each(this.steps, function(step) {
        var view;
        view = new App.Views.WizardStepListItem({
          step: step
        });
        view.setPercentageWidth(100 / _this.steps.length);
        return _this.insertView(view);
      });
    };

    WizardStepList.prototype.afterRender = function() {
      return this._adjustSeparatorWidth();
    };

    WizardStepList.prototype.cleanup = function() {
      return this.eventDispatcher.off(null, null, this);
    };

    WizardStepList.prototype._adjustSeparatorWidth = function() {
      var prev, views;
      prev = null;
      views = this.views[''];
      return _.each(views, function(view, index) {
        var $sep, offset;
        if (prev) {
          offset = view.$('.step').offset();
          $sep = prev.$('.separator');
          $sep.css('width', offset.left - $sep.offset().left);
        }
        return prev = view;
      });
    };

    return WizardStepList;

  })(Backbone.LayoutView);

}).call(this);
