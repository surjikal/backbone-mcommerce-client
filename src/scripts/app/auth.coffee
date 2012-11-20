
class App.Auth

    urls:
        router:
            login: "/login"
        api:
            validate: "#{App.config.urls.api}/auth/validate/"

    isLoggedIn: false

    constructor: ->
        @events = _.extend {}, Backbone.Events

    initialize: ->
        @_loginFromSavedCredentials()

    login: (email, password, callbacks = {}) ->
        callbacks.success = _.wrap callbacks.success, (success) =>
            @_login email, password
            success? email, password
        @_validate email, password, callbacks

    logout: ->
        console.debug "Logging out current user."
        Backbone.BasicAuth.clear()
        @_clearSavedCredentials()
        @isLoggedIn = false
        @events.trigger 'logout'

    onUnauthorizedResponse: ->
        @events.trigger 'unauthorized'

    _loginFromSavedCredentials: ->
        {email, password} = @_loadCredentials()
        @_login email, password if (email and password)

    _login: (email, password) ->
        console.debug "Logging in user #{email}."
        @_saveCredentials email, password
        Backbone.BasicAuth.set email, password
        @isLoggedIn = true
        @events.trigger 'login'

    _validate: (email, password, callbacks) ->
        data = {email, password}
        url  = @urls.api.validate
        App.utils.json.post {url, data, callbacks}

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

