
class App.Auth

    isLoggedIn: false

    constructor: ->
        @events = _.extend {}, Backbone.Events

        # TODO: Switch to native secure storage in phonegap.
        @credentialStore = new LocalStorageCredentialStore()

    initialize: ->
        @_initializeUser()

    # Callbacks
    # - success:    the credentials are valid
    # - incorrect:  the credentials are not valid (i.e. user doesn't exist, bad email/pw combo)
    # - disabled:   the account associated to the credentials has been disabled
    login: (email, password, callbacks = {}) ->
        callbacks.success = _.wrap callbacks.success, (success) =>
            @_resetUser()
            @_login email, password
            success? @user
        App.api.auth.validate email, password, callbacks

    # Callbacks
    # - success:        the user was created successfully
    # - invalid:        the parameters supplied we not valid (i.e. bad email address)
    # - alreadyInUse:   the email supplied belongs to an existing account
    register: (email, password, callbacks = {}) ->
        callbacks.success = _.wrap callbacks.success, (success) =>
            @_resetUser()
            @_login email, password
            success? @user
        App.api.auth.register email, password, callbacks

    logout: ->
        console.debug "Logging out user."
        @_resetUser()
        @isLoggedIn = false
        @events.trigger 'logout'
        # FIXME: Workaround for the "missing url property" bug... see 'purchase wizard' route for details.
        window.location.href = window.location.href

    _initializeUser: ->
        @user = new App.Models.User()
        {email, password} = @credentialStore.load()
        @login email, password if (email and password)

    _resetUser: ->
        @user.clear()
        @credentialStore.clear()
        localStorage.clear()
        Backbone.BasicAuth.clear()
        @user = new App.Models.User()

    _login: (email, password) ->
        console.debug "Logging in user #{email}."
        @_resetUser()
        Backbone.BasicAuth.set email, password
        @credentialStore.save email, password
        @isLoggedIn = true
        @user.set 'email', email
        @events.trigger 'login'


class LocalStorageCredentialStore

    save: (email, password) ->
        localStorage.setItem 'email',    email
        localStorage.setItem 'password', password

    load: ->
        email:    localStorage.getItem 'email'
        password: localStorage.getItem 'password'

    clear: ->
        localStorage.removeItem 'email'
        localStorage.removeItem 'password'

