
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

    Templates: Handlebars.templates

    Models: {}

    Views:
        Utils: {}

    Layouts: {}
    Collections: {}

    views: {}
    models: {}
    layouts: {}
    collections: {}

exports = exports ? this
exports.App = App
