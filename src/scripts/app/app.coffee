
App =

    initialize: ->
        console.debug 'Initializing the app.'

        App.auth       = new App.Auth()
        App.router     = new App.Router()
        App.views.main = new App.Views.Main()

        App.collections.boutiques = new App.Collections.Boutique()
        App.models.user           = new App.Models.User()

        @initializeApi()
        @loginFromSavedCredentials()

    initializeApi: ->
        rootUrl = App.config.urls.api
        App.api.auth = new App.Api.Auth rootUrl

    loginFromSavedCredentials: ->
        {email, password} = App.auth.loadCredentials()
        App.models.user.login email, password if (email and password)

    Templates: Handlebars.templates

    events: _.extend {}, Backbone.Events

    Api: {}
    Collections: {}
    Layouts: {}
    Models: {}
    Views:
        Utils: {}

    api: {}
    collections: {}
    layouts: {}
    models: {}
    views: {}

    # Initialized in the index file.
    config: {}


exports = exports ? this
exports.App = App
