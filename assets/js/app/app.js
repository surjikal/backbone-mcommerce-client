(function() {
  var App, exports;

  App = {
    initialize: function() {
      console.debug('Initializing the app.');
      App.auth = new App.Auth();
      App.router = new App.Router();
      App.api = new App.Api();
      App.views.main = new App.Views.Main();
      App.collections.boutiques = new App.Collections.Boutique();
      App.api.initialize(App.config.urls.api);
      App.auth.initialize();
      if (App.config.offlineMode) {
        return App.loadOfflineData();
      }
    },
    getAbsoluteUrl: function(relativeUrl) {
      return "" + App.location + "/" + relativeUrl;
    },
    templates: Handlebars.templates,
    location: "" + location.protocol + "//" + location.host,
    events: _.extend({}, Backbone.Events),
    Api: {},
    Collections: {},
    Layouts: {},
    Models: {},
    Views: {
      Utils: {}
    },
    Controllers: {},
    api: {},
    collections: {},
    layouts: {},
    models: {},
    views: {},
    config: {}
  };

  exports = exports != null ? exports : this;

  exports.App = App;

}).call(this);
