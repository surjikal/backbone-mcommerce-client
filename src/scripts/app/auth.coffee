
class App.Auth

    urls:
        router:
            login: "/login"
        api:
            login: "#{App.config.urls.api}/auth/login/"
            logout: "#{App.config.urls.api}/auth/logout/"

    constructor: ->
        @_authenticateFromSavedCredentials()

    login: (email, password, callbacks = {}) ->
        console.debug "Login request for user '#{email}'."
        @authenticate email, password
        callbacks?.success?()

    logout: (callbacks) ->
        console.debug "Logging out current user."
        Backbone.BasicAuth.clear()

    _authenticate: (email, password) ->
        Backbone.BasicAuth.set email, password
        @_saveCredentials email, password

    _saveCredentials: (email, password) ->
        $.cookie 'email', email
        $.cookie 'password', password

    _loadCredentials: ->
        email    = $.cookie 'email'
        password = $.cookie 'password'
        if email and password then {email, password} else {}

    _authenticateFromSavedCredentials: ->
        {email, password} = @_loadCredentials()
        @_authenticate email, password if email and password
