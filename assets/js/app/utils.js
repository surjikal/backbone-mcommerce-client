(function() {

  App.utils = {
    json: {
      post: function(options) {
        options.type = 'post';
        return this.ajax(options);
      },
      get: function(options) {
        options.type = 'get';
        return this.ajax(options);
      },
      ajax: function(_arg) {
        var auth, callbacks, data, type, url,
          _this = this;
        url = _arg.url, type = _arg.type, data = _arg.data, auth = _arg.auth, callbacks = _arg.callbacks;
        if (!url) {
          throw "Missing url option.";
        }
        if (!type) {
          throw "Missing type option.";
        }
        if (!callbacks) {
          console.warn("No callbacks specified.");
          callbacks = {};
        }
        return $.ajax({
          url: url,
          type: type,
          dataType: 'json',
          contentType: 'application/json',
          data: data ? JSON.stringify(data) : void 0,
          headers: auth ? {
            Authorization: auth
          } : void 0,
          error: function(jqXHR, textStatus, errorThrown) {
            var callback, reason, response;
            response = _this._parseReponseText(jqXHR.responseText);
            response = (function() {
              switch (jqXHR.status) {
                case 500:
                  return response || {
                    reason: 'serverError'
                  };
                case 401:
                  this._handleUnauthorizedError(jqXHR);
                  return response || {
                    reason: 'unauthorized'
                  };
                default:
                  return response;
              }
            }).call(_this);
            reason = response != null ? response.reason : void 0;
            callback = callbacks[response != null ? response.reason : void 0];
            if (!callback && reason) {
              console.debug(response);
              console.debug("Error reason '" + reason + "' unhandled. Reverting to 'error' callback (if any).");
              callback = callbacks.error;
            }
            return typeof callback === "function" ? callback(jqXHR, textStatus, errorThrown) : void 0;
          },
          success: function(data) {
            return callbacks.success(data);
          }
        });
      },
      _parseReponseText: function(responseText) {
        var response;
        try {
          return response = JSON.parse(responseText);
        } catch (_error) {}
      },
      _handleInternalServerError: function(jqXHR) {
        var error, errorMessage, responseText;
        responseText = jqXHR.responseText;
        error = this._parseReponseText(responseText);
        errorMessage = "Internal server error:\n\n";
        if (error) {
          if (error.errorMessage) {
            errorMessage += "" + error.errorMessage + "\n\n";
          }
          errorMessage += "" + error.traceback;
        } else {
          errorMessage += responseText;
        }
        return console.error(errorMessage);
      },
      _handleUnauthorizedError: function(jqXHR) {
        return console.error("Unauthorized to make this ajax call.");
      }
    },
    guid: (function() {
      var S4;
      S4 = function() {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
      };
      return function() {
        return "" + (S4()) + (S4()) + "-" + (S4()) + "-" + (S4()) + "-" + (S4()) + (S4()) + (S4());
      };
    })(),
    getRandomNumber: function(min, max) {
      return Math.random() * (max - min + 1) + min;
    },
    getRandomInteger: function(min, max) {
      return Math.floor(this.getRandomNumber(min, max));
    }
  };

}).call(this);
