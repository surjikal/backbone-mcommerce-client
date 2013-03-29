(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Views.BoutiqueSelect = (function(_super) {

    __extends(BoutiqueSelect, _super);

    function BoutiqueSelect() {
      this.scanButtonClicked = __bind(this.scanButtonClicked, this);

      this.navigateToBoutiqueButtonClicked = __bind(this.navigateToBoutiqueButtonClicked, this);
      return BoutiqueSelect.__super__.constructor.apply(this, arguments);
    }

    BoutiqueSelect.prototype.template = 'boutique-select';

    BoutiqueSelect.prototype.className = 'boutique-select-view';

    BoutiqueSelect.prototype.events = _.extend({}, App.Views.FormView.prototype.events, {
      'click #navigate-to-boutique-button': 'navigateToBoutiqueButtonClicked',
      'click #scan-button': 'scanButtonClicked'
    });

    BoutiqueSelect.prototype.onEmptyBoutiqueCode = function() {
      return this.errorAlert("Please enter a boutique code.");
    };

    BoutiqueSelect.prototype.onBoutiqueCodeNotFound = function(boutiqueCode) {
      return this.errorAlert("Boutique '" + boutiqueCode + "' wasn't found. Try again :)");
    };

    BoutiqueSelect.prototype.getBoutiqueCode = function() {
      return (this.$el.find('#boutique-code')).val();
    };

    BoutiqueSelect.prototype.navigateToBoutiqueButtonClicked = function(event) {
      var _this = this;
      return (this.withLoadingSpinner(event))({
        onEvent: function(loader) {
          var boutiqueCode;
          event.preventDefault();
          if (!(boutiqueCode = _this.getBoutiqueCode())) {
            return _this.onEmptyBoutiqueCode();
          }
          loader.start();
          return App.collections.boutiques.getOrFetch(boutiqueCode, {
            success: loader.callback(function(boutique) {
              return _this.navigateToBoutique(boutique);
            }),
            notFound: loader.callback(function() {
              return _this.onBoutiqueCodeNotFound(boutiqueCode);
            })
          });
        }
      });
    };

    BoutiqueSelect.prototype.navigateToBoutique = function(boutique) {
      var boutiqueCode;
      boutiqueCode = boutique.get('code');
      return App.router.navigate("/boutiques/" + boutiqueCode, {
        trigger: true
      });
    };

    BoutiqueSelect.prototype.navigateToItemspot = function(boutiqueCode, itemspotIndex) {
      return App.router.navigate("/boutiques/" + boutiqueCode + "/items/" + itemspotIndex, {
        trigger: true
      });
    };

    BoutiqueSelect.prototype.scanButtonClicked = function(e) {
      return (this.withLoadingSpinner(e))({
        target: '#scan-button',
        timeout: -1,
        onEvent: function(loader) {
          var controller,
            _this = this;
          loader.start();
          controller = new App.Controllers.BarcodeScanner();
          return controller.scan({
            success: function(boutiqueCode, itemspotIndex) {
              return App.collections.boutiques.getOrFetch(boutiqueCode, {
                success: loader.callback(function() {
                  return _this.navigateToItemspot(boutiqueCode, itemspotIndex);
                }),
                notFound: loader.callback(function() {
                  return _this.onBoutiqueCodeNotFound(boutiqueCode);
                })
              });
            },
            cancelled: loader.callback(function() {
              return console.log("User cancelled barcode scanner.");
            }),
            scanError: loader.callback(function() {
              console.error("Scanner error:", errorMessage);
              return _this.errorAlert("Something went wrong with the scanner. Please, try again!");
            }),
            parseError: loader.callback(function() {
              console.error("Could not parse scanned data. Data:", scannedData);
              return _this.errorAlert("I couldn't read the barcode :(. Please, try again!");
            })
          });
        }
      });
    };

    return BoutiqueSelect;

  })(App.Views.FormView);

  App.Controllers.BarcodeScanner = (function() {

    function BarcodeScanner() {}

    BarcodeScanner.prototype.scan = function(_arg) {
      var cancelled, parseError, scanError, success,
        _this = this;
      success = _arg.success, cancelled = _arg.cancelled, parseError = _arg.parseError, scanError = _arg.scanError;
      return this._scan({
        cancelled: cancelled,
        error: scanError,
        success: function(data, type) {
          console.debug("Scan success (" + type + "):", data);
          return _this._parseScannedData(data, {
            success: success,
            parseError: parseError
          });
        }
      });
    };

    BarcodeScanner.prototype._scan = function(_arg) {
      var cancelled, error, onScanError, onScanSuccess, success,
        _this = this;
      success = _arg.success, cancelled = _arg.cancelled, error = _arg.error;
      onScanSuccess = function(result) {
        if (result.cancelled) {
          return typeof cancelled === "function" ? cancelled() : void 0;
        }
        return typeof success === "function" ? success(result.text, result.type) : void 0;
      };
      onScanError = function(errorMessage) {
        return typeof error === "function" ? error(errorMessage) : void 0;
      };
      return _.defer(function() {
        return _this._callScanPlugin(onScanSuccess, onScanError);
      });
    };

    BarcodeScanner.prototype._parseScannedData = function(scannedData, _arg) {
      var boutiqueCode, error, itemspotIndex, success, tokens;
      success = _arg.success, error = _arg.error;
      return typeof success === "function" ? success('gifts4gf', '5') : void 0;
      tokens = scannedData.split('#');
      if (tokens.length !== 2) {
        return typeof error === "function" ? error(scannedData) : void 0;
      }
      boutiqueCode = tokens[0], itemspotIndex = tokens[1];
      return typeof success === "function" ? success(boutiqueCode, itemspotIndex) : void 0;
    };

    BarcodeScanner.prototype._callScanPlugin = function() {
      var _ref;
      return (_ref = window.plugins.barcodeScanner).scan.apply(_ref, arguments);
    };

    return BarcodeScanner;

  })();

  App.Controllers.MockBarcodeScanner = (function() {

    function MockBarcodeScanner() {}

    MockBarcodeScanner.prototype.scan = function(_arg) {
      var cancelled, parseError, scanError, success;
      success = _arg.success, cancelled = _arg.cancelled, parseError = _arg.parseError, scanError = _arg.scanError;
      return typeof success === "function" ? success('vipl', 5) : void 0;
    };

    return MockBarcodeScanner;

  })();

}).call(this);
