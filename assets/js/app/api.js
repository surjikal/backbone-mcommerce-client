(function() {
  var Api,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  App.Api = (function() {

    function Api() {}

    Api.prototype.initialize = function(baseUrl) {
      this.baseUrl = baseUrl;
      this.auth = new App.Api.Auth(this.baseUrl);
      return this.purchase = new App.Api.Purchase(this.baseUrl);
    };

    return Api;

  })();

  Api = (function() {

    function Api(baseUrl) {
      this.baseUrl = baseUrl;
    }

    Api.prototype.url = function(action) {
      return "" + this.baseUrl + "/" + this.resource + "/" + action + "/";
    };

    Api.prototype.post = function(action, data, callbacks) {
      var options, url;
      url = this.url(action);
      options = {
        url: url,
        data: data,
        callbacks: callbacks
      };
      if (App.auth.isLoggedIn) {
        options.auth = "Basic " + App.auth.token;
      }
      return App.utils.json.post(options);
    };

    return Api;

  })();

  App.Api.Auth = (function(_super) {

    __extends(Auth, _super);

    function Auth() {
      return Auth.__super__.constructor.apply(this, arguments);
    }

    Auth.prototype.resource = 'auth';

    Auth.prototype.validate = function(email, password, callbacks) {
      return this.post('validate', {
        email: email,
        password: password
      }, callbacks);
    };

    Auth.prototype.register = function(email, password, callbacks) {
      return this.post('register', {
        email: email,
        password: password
      }, callbacks);
    };

    return Auth;

  })(Api);

  App.Api.Purchase = (function(_super) {

    __extends(Purchase, _super);

    function Purchase() {
      return Purchase.__super__.constructor.apply(this, arguments);
    }

    Purchase.prototype.resource = 'purchase';

    Purchase.prototype.getToken = function(address, itemspot, successUrl, cancelUrl, callbacks) {
      var boutique, data;
      address = address.toJSON();
      boutique = {
        code: itemspot.getBoutiqueCode()
      };
      itemspot = {
        index: itemspot.get('index')
      };
      data = {
        address: address,
        boutique: boutique,
        itemspot: itemspot,
        successUrl: successUrl,
        cancelUrl: cancelUrl
      };
      return this.post('get_token', data, callbacks);
    };

    Purchase.prototype.getDetails = function(token) {
      return this.post('get_details', {
        token: token
      }, callbacks);
    };

    return Purchase;

  })(Api);

}).call(this);
