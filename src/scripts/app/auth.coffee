
class App.Auth

    isLoggedIn: false

    constructor: ->
        @events = _.extend {}, Backbone.Events

    initialize: ->
        @_loginFromSavedCredentials()

    login: (email, password, callbacks = {}) ->
        callbacks.success = _.wrap callbacks.success, (success) =>
            @_login email, password
            success? @_resetUser()
        App.api.auth.validate email, password, callbacks

    register: (email, password, callbacks = {}) ->
        callbacks.success = _.wrap callbacks.success, (success) =>
            @_login email, password
            success? @_resetUser()
        App.api.auth.register email, password, callbacks

    logout: ->
        console.debug "Logging out current user."
        Backbone.BasicAuth.clear()
        @_clearSavedCredentials()
        @isLoggedIn = false
        @events.trigger 'logout'

    _resetUser: ->
        App.models.user.clear()
        App.models.user = new App.Models.User()

    _loginFromSavedCredentials: ->
        {email, password} = @_loadCredentials()
        @_login email, password if (email and password)

    _login: (email, password) ->
        console.debug "Logging in user #{email}."
        @_saveCredentials email, password
        Backbone.BasicAuth.set email, password
        @isLoggedIn = true
        @events.trigger 'login'

    _saveCredentials: (email, password) ->
        localStorage.setItem 'email', email
        localStorage.setItem 'password', password

    _loadCredentials: ->
        email    = localStorage.getItem 'email'
        password = localStorage.getItem 'password'
        if (email and password) then {email, password} \
                                else {}
    _clearSavedCredentials: ->
        localStorage.removeItem 'email'
        localStorage.removeItem 'password'

