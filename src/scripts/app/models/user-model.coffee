
class App.Models.User extends Backbone.Model

    defaults:
        email: null
        password: null
        addresses: null

    initialize: ->
        console.debug 'Initializing user model.'
        @addresses = new App.Collections.Address()

    isAuthenticated: ->
        return (@email and @password)

    url: ->
        "#{App.apiUrlRoot}/users/#{@id}/"