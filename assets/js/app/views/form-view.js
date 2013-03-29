(function() {
  var LOADING_TIMEOUT,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  LOADING_TIMEOUT = 10000;

  App.Views.FormView = (function(_super) {

    __extends(FormView, _super);

    function FormView() {
      this.withLoadingSpinner = __bind(this.withLoadingSpinner, this);

      this.onPendingTimeout = __bind(this.onPendingTimeout, this);
      return FormView.__super__.constructor.apply(this, arguments);
    }

    FormView.prototype.events = {
      'submit': function() {
        return false;
      }
    };

    FormView.prototype.initiliaze = function() {
      return this.fields = this.fields || {};
    };

    FormView.prototype.getField = function(fieldName) {
      var selector;
      selector = this.fields[fieldName];
      return this.$(selector);
    };

    FormView.prototype.getFieldValue = function(fieldName) {
      return (this.getField(fieldName)).val();
    };

    FormView.prototype.setFieldValue = function(fieldName, value) {
      return (this.getField(fieldName)).val(value);
    };

    FormView.prototype.getFieldValues = function() {
      var fieldNames, fields,
        _this = this;
      fieldNames = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      fields = _.isEmpty(fieldNames) ? this.fields : _.pick.apply(_, [this.fields].concat(__slice.call(fieldNames)));
      return _.objMap(fields, function(selector, name) {
        return _this.getFieldValue(name);
      });
    };

    FormView.prototype.setFieldErrors = function(fieldNames) {
      var name, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = fieldNames.length; _i < _len; _i++) {
        name = fieldNames[_i];
        _results.push(this.setFieldError(name));
      }
      return _results;
    };

    FormView.prototype.setFieldError = function(fieldName) {
      return (this.getField(fieldName)).addClass('error');
    };

    FormView.prototype.clearFieldErrors = function() {
      return (this.$('input')).removeClass('error');
    };

    FormView.prototype.clearFieldError = function($el) {
      return $el.removeClass('error');
    };

    FormView.prototype.errorAlert = function(message) {
      return _.defer(function() {
        return alert(message);
      });
    };

    FormView.prototype.getSubmitButton = function() {
      return this.$('button[type="submit"]');
    };

    FormView.prototype.getSubmitButtonText = function() {
      return this.getSubmitButton().text();
    };

    FormView.prototype.setSubmitButtonText = function(text) {
      var $button;
      $button = this.getSubmitButton();
      return $button.text(text);
    };

    FormView.prototype.enablePending = function(buttonSelector, timeout) {
      var showLoadingSpinner,
        _this = this;
      if (timeout == null) {
        timeout = LOADING_TIMEOUT;
      }
      if (_.isNumber(buttonSelector)) {
        timeout = buttonSelector;
        buttonSelector = null;
      }
      showLoadingSpinner = function() {
        var $button;
        $button = buttonSelector ? _this.$(buttonSelector) : _this.getSubmitButton();
        return $button.addClass('loading');
      };
      this.pending = true;
      showLoadingSpinner();
      if (timeout >= 0) {
        return this.pendingTimer = setTimeout(this.onPendingTimeout, timeout);
      }
    };

    FormView.prototype.onPendingTimeout = function() {
      this.disablePending();
      return this.errorAlert('The server is not responding :(. Please try again.');
    };

    FormView.prototype.disablePending = function() {
      var _ref;
      clearTimeout(this.pendingTimer);
      this.pending = false;
      return (_ref = this.$('.loading')) != null ? _ref.removeClass('loading') : void 0;
    };

    FormView.prototype.cleanup = function() {
      console.debug('Cleaning up form view.');
      this.disablePending();
      return clearTimeout(this.timer);
    };

    FormView.prototype.withLoadingSpinner = function(event) {
      var _this = this;
      return function(_arg) {
        var getTargetEl, initTimer, loader, onEvent, onTimeout, startLoading, stopLoading, target, timeout, _onTimeout;
        target = _arg.target, timeout = _arg.timeout, onEvent = _arg.onEvent, onTimeout = _arg.onTimeout;
        if (_this.isLoading) {
          return false;
        }
        if (!timeout) {
          timeout = LOADING_TIMEOUT;
        }
        getTargetEl = target ? (function() {
          return _this.$(target);
        }) : _this.getSubmitButton;
        startLoading = function() {
          var $target;
          _this.timer = timeout >= 0 ? initTimer() : null;
          _this.isLoading = true;
          $target = getTargetEl();
          return $target.addClass('loading');
        };
        stopLoading = function() {
          var $target;
          clearTimeout(_this.timer);
          _this.timer = null;
          _this.isLoading = false;
          $target = getTargetEl();
          return $target.removeClass('loading');
        };
        _onTimeout = function() {
          stopLoading();
          if (onTimeout) {
            return onTimeout.call(_this);
          } else {
            return _this.errorAlert('The server is not responding :(. Please try again.');
          }
        };
        initTimer = function() {
          return setTimeout(_onTimeout, timeout);
        };
        loader = {
          start: startLoading,
          stop: stopLoading,
          callback: function(handler) {
            return function() {
              if (!_this.isLoading) {
                return console.debug('Callback timed-out; not calling handler.');
              }
              stopLoading();
              return handler.apply(_this, arguments);
            };
          }
        };
        return onEvent.call(_this, loader);
      };
    };

    return FormView;

  })(Backbone.LayoutView);

}).call(this);
