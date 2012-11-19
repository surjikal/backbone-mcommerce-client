

class AuthPersistenceBackend

    set: (username, password) ->
        localStorage.setItem 'email',    email
        localStorage.setItem 'password', password
        Backbone.BasicAuth.set email, password

    get: ->
        email:    localStorage.getItem 'email'
        password: localStorage.getItem 'password'

    clear: ->
        localStorage.removeItem 'email'
        localStorage.removeItem 'password'
        Backbone.BasicAuth.clear()



class App.Models.Session extends Backbone.Model

    defaults:
        email: null
        password: null

    isAuthenticated: false

    initialize: ->
        @backend = new AuthPersistenceBackend()
        @load()

    save: (email, password)->
        @backend.set username, password
        @isAuthenticated = true

    load: ->
        @set @backend.get()

    clear: ->
        @backend.clear()
        super
