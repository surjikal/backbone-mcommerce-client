
App =

    config:
        urls:
            root: '/'
            api: '/api'
            static: '/static'

        debug:
            mockStripeAPI: true


    initialize: ->
        console.debug 'Initializing the app.'

        App.auth       = new App.Auth()
        App.router     = new App.Router()
        App.views.main = new App.Views.Main()

        App.collections.boutiques = new App.Collections.Boutique()
        App.models.user           = new App.Models.User()

        App.auth.initialize()
        @initializeApi()


    initializeApi: ->
        rootUrl = App.config.urls.api
        App.api.auth = new App.Api.Auth rootUrl


    Templates: Handlebars.templates

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


exports = exports ? this
exports.App = App
