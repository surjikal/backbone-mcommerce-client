
class App.Models.User extends Backbone.Model

    defaults:
        session: null
        addresses: null

    initialize: (options) ->
        console.debug 'Initializing user model.'
        @addresses = new App.Collections.Address()

    isLoggedIn: ->
        App.auth.isLoggedIn
