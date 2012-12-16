
App =

    initialize: ->
        console.debug 'Initializing the app.'

        App.auth       = new App.Auth()
        App.router     = new App.Router()
        App.views.main = new App.Views.Main()

        App.collections.boutiques = new App.Collections.Boutique()
        App.models.user           = new App.Models.User()

        @initializeApi()
        App.auth.initialize()


    initializeApi: ->
        rootUrl = App.config.urls.api
        App.api.auth     = new App.Api.Auth     rootUrl
        App.api.purchase = new App.Api.Purchase rootUrl

    getAbsoluteUrl: (relativeUrl) ->
        "#{App.location}/#{relativeUrl}"

    templates: Handlebars.templates

    location: "#{location.protocol}//#{location.host}"

    events: _.extend {}, Backbone.Events

    Api: {}
    Collections: {}
    Layouts: {}
    Models: {}
    Views:
        Utils: {}
    Controllers: {}

    api: {}
    collections: {}
    layouts: {}
    models: {}
    views: {}

    # Initialized in the index file.
    config: {}


exports = exports ? this
exports.App = App
