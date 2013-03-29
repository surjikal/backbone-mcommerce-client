(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.WizardStep = (function(_super) {

    __extends(WizardStep, _super);

    function WizardStep() {
      return WizardStep.__super__.constructor.apply(this, arguments);
    }

    WizardStep.prototype.events = _.extend({}, App.Views.FormView.prototype.events, {
      'click #wizard-next-step': 'wizardNextStepClicked'
    });

    WizardStep.prototype.initialize = function(options) {
      WizardStep.__super__.initialize.apply(this, arguments);
      this.step = options.step;
      return this.eventDispatcher = options.eventDispatcher;
    };

    WizardStep.prototype.beforeNextStep = function(done) {
      return done();
    };

    WizardStep.prototype.setStatusBarView = function(view) {
      return this.setView('#wizard-status-bar', view);
    };

    WizardStep.prototype.setContentView = function(view) {
      return this.setView('#wizard-step-contents', view);
    };

    WizardStep.prototype.wizardNextStepClicked = function(event) {
      event.preventDefault();
      this.complete();
      return false;
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

    WizardStep.prototype.complete = function(data) {
      var _this = this;
      return this.beforeNextStep(function(data) {
        if (data == null) {
          data = {};
        }
        return _this.eventDispatcher.trigger('step:completed', {
          step: _this.step,
          data: data
        });
      });
    };

    return WizardStep;

  })(App.Views.FormView);

}).call(this);
