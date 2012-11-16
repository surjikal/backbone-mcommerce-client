
App =

    config:

        urls:
            root: '/'
            api: '/api'
            static: '/static'

        debug:
            mockStripeAPI: true

        cookies:
            secure: false
            expires: 365


    initialize: ->
        console.debug 'Initializing app.'
        App.router = new App.Router()
        
        App.collections.boutiques = new App.Collections.Boutique()
        App.models.user = new App.Models.User()

        @auth = new App.Auth()


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
