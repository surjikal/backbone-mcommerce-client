(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

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

  App.Views.WizardStep = (function(_super) {

    __extends(WizardStep, _super);

    function WizardStep() {
      return WizardStep.__super__.constructor.apply(this, arguments);
    }

    WizardStep.prototype.events = {
      'click #wizard-next-step': 'wizardNextStepClicked',
      'submit': function() {
        return false;
      }
    };

    WizardStep.prototype.initialize = function(options) {
      var unmetDependencies;
      WizardStep.__super__.initialize.apply(this, arguments);
      this.step = options._step;
      this.eventDispatcher = options._eventDispatcher;
      if (this.dependencies) {
        unmetDependencies = this._checkForUnmetDependencies(options.wizardData, this.dependencies);
        if (!_.isEmpty(unmetDependencies)) {
          return this.eventDispatcher.trigger('step:unmetDependencies', {
            step: this.step,
            unmetDependencies: unmetDependencies
          });
        }
      }
    };

    WizardStep.prototype.wizardNextStepClicked = function(event) {
      var _this = this;
      event.preventDefault();
      this.beforeNextStep(function(data) {
        if (data == null) {
          data = {};
        }
        return _this.completed(data);
      });
      return false;
    };

    WizardStep.prototype._checkForUnmetDependencies = function(wizardData, dependencies) {
      var availableData, key, value;
      availableData = (function() {
        var _results;
        _results = [];
        for (key in wizardData) {
          value = wizardData[key];
          if (Boolean(value)) {
            _results.push(key);
          }
        }
        return _results;
      })();
      return _.difference(dependencies, availableData);
    };

    WizardStep.prototype._addUrlParameter = function(key, value) {
      return this.eventDispatcher.trigger('step:addUrlParameter', {
        step: this.step,
        parameter: {
          key: key,
          value: value
        }
      });
    };

    WizardStep.prototype.beforeRender = function() {
      if (this.wizardStepListView) {
        return this.setView('#wizard-step-list', this.wizardStepListView);
      }
    };

    WizardStep.prototype.setWizardStepListView = function(wizardStepListView) {
      this.wizardStepListView = wizardStepListView;
    };

    WizardStep.prototype.beforeNextStep = function(done) {
      return done();
    };

    WizardStep.prototype.completed = function(data) {
      this.step.state = 'complete';
      return this.eventDispatcher.trigger('step:completed', {
        data: data,
        step: this.step
      });
    };

    return WizardStep;

  })(App.Views.FormView);

  App.Views.Wizard = (function(_super) {

    __extends(Wizard, _super);

    function Wizard() {
      this.onUnmetDependencies = __bind(this.onUnmetDependencies, this);

      this.onAddUrlParameter = __bind(this.onAddUrlParameter, this);

      this.onStepCompleted = __bind(this.onStepCompleted, this);
      return Wizard.__super__.constructor.apply(this, arguments);
    }

    Wizard.prototype.className = 'wizard-view';

    Wizard.prototype._data = {};

    Wizard.prototype.initialize = function(options) {
      var initialStepId, step, stepIndex, steps, _i, _len, _ref, _ref1;
      console.debug('Initializing wizard.');
      steps = this.steps || options.steps;
      if (!steps) {
        throw new Error("Wizard has no steps.");
      }
      this.initializeEventDispatcher();
      this.steps = this.createSteps(steps, this.eventDispatcher);
      this.stepOrder = this.createStepOrder(this.steps);
      this.stepIdMap = this.createStepIdMap(this.steps);
      if (options.step) {
        console.debug("Starting wizard at step '" + options.step + "'.");
        if (!(_ref = options.step, __indexOf.call(this.stepOrder, _ref) >= 0)) {
          throw new Error("Initial step '" + options.step.id + "' not found in steps " + (this.steps.join(', ')) + "'.");
        }
        stepIndex = this.stepOrder.indexOf(options.step);
        _ref1 = this.steps.slice(0, stepIndex + 1 || 9e9);
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          step = _ref1[_i];
          console.debug("Completing step '" + step.id + "'.");
          step.state = 'complete';
        }
      }
      initialStepId = options.step || this.getFirstStepId();
      if (options.wizardData) {
        console.debug("Preloading wizard with data:\n", options.wizardData);
        this._data = options.wizardData;
      }
      this.initStepListView();
      return this.setStep(initialStepId, this._data);
    };

    Wizard.prototype.initializeEventDispatcher = function() {
      this.eventDispatcher = _.extend({}, Backbone.Events);
      this.eventDispatcher.on('step:completed', this.onStepCompleted);
      this.eventDispatcher.on('step:addUrlParameter', this.onAddUrlParameter);
      return this.eventDispatcher.on('step:unmetDependencies', this.onUnmetDependencies);
    };

    Wizard.prototype.onStepCompleted = function(_arg) {
      var data, nextStepId, step;
      step = _arg.step, data = _arg.data;
      console.debug("Step '" + step.id + "' completed.");
      nextStepId = this.getNextStepId(step.id);
      this._data = _.extend(this._data, data);
      if (nextStepId) {
        return this.setStep(nextStepId, this._data, true);
      }
      return this.completed(this._data, function() {
        return step = 'complete';
      });
    };

    Wizard.prototype.onAddUrlParameter = function(_arg) {
      var parameter, search, separator, step;
      step = _arg.step, parameter = _arg.parameter;
      search = window.location.search;
      separator = !search ? '?' : '&';
      return this._setUrl("" + (this.getStepUrl(step.id)) + window.location.search + separator + parameter.key + "=" + parameter.value);
    };

    Wizard.prototype.onUnmetDependencies = function(_arg) {
      var step, unmetDependencies;
      step = _arg.step, unmetDependencies = _arg.unmetDependencies;
      return console.warn("Dependencies '[" + (unmetDependencies.join(', ')) + "]' not met for wizard step '" + step.id + "'.");
    };

    Wizard.prototype.createSteps = function(steps, eventDispatcher) {
      var _this = this;
      return _.map(steps, function(step, index) {
        step._createView = step.initialize({
          _eventDispatcher: eventDispatcher,
          _step: step
        });
        step._index = index;
        step.state = '';
        return step;
      });
    };

    Wizard.prototype.createStepOrder = function(steps) {
      return _.pluck(steps, 'id');
    };

    Wizard.prototype.createStepIdMap = function(steps) {
      var step, stepIdMap, _i, _len;
      stepIdMap = {};
      for (_i = 0, _len = steps.length; _i < _len; _i++) {
        step = steps[_i];
        stepIdMap[step.id] = step;
      }
      return stepIdMap;
    };

    Wizard.prototype.initStepListView = function() {
      return this.stepListView = new App.Views.WizardStepList({
        steps: this.steps,
        eventDispatcher: this.eventDispatcher
      });
    };

    Wizard.prototype.getFirstStepId = function() {
      return _.first(this.stepOrder);
    };

    Wizard.prototype.getStepObject = function(id) {
      return this.stepIdMap[id] || (function() {
        throw new Error("Step '" + id + "' not found.");
      })();
    };

    Wizard.prototype.getStepIdAt = function(index) {
      return this.stepOrder[index];
    };

    Wizard.prototype.getNextStepId = function(id) {
      var nextIndex, step;
      step = this.getStepObject(id);
      nextIndex = step._index + 1;
      if (nextIndex >= this.stepOrder.length) {
        return console.debug("Already at last step.");
      }
      return this.getStepIdAt(nextIndex);
    };

    Wizard.prototype.setStep = function(id, data, render) {
      var step;
      if (render == null) {
        render = false;
      }
      console.debug("Setting wizard to '" + id + "' step.");
      step = this.getStepObject(id);
      this._resetIncompleteStepStates();
      this._setUrl("" + (this.getStepUrl(id)) + window.location.search);
      step.state = 'active';
      if (this.stepView) {
        this.stepView.close();
      }
      this.stepView = step._createView(data);
      this.setView(this.stepView);
      this.stepView.setWizardStepListView(this.stepListView);
      if (render) {
        return this.stepView.render();
      }
    };

    Wizard.prototype.completed = function(data, done) {
      console.warn('Wizard completed, but derived class is not handling it.');
      return done();
    };

    Wizard.prototype._resetIncompleteStepStates = function() {
      return this.steps = _.map(this.steps, function(step, index) {
        if (step.state !== 'complete') {
          step.state = '';
        }
        return step;
      });
    };

    Wizard.prototype._setUrl = function(url) {
      return App.router.navigate(url, {
        trigger: false,
        replace: true
      });
    };

    return Wizard;

  })(Backbone.LayoutView);

}).call(this);
