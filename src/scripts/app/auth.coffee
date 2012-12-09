
class App.Auth

    isLoggedIn: false

    constructor: ->
        @events = _.extend {}, Backbone.Events
        @credentialStore = new LocalStorageCredentialStore()

    initialize: ->
        @_initializeUser()

    login: (email, password, callbacks = {}) ->
        callbacks.success = _.wrap callbacks.success, (success) =>
            @_resetUser()
            @_login email, password
            success? @user
        App.api.auth.validate email, password, callbacks

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
        # Workaround for the "missing url property" bug... see 'purchase wizard' route for details.
        window.location.href = window.location.href
        @events.trigger 'logout'

    _initializeUser: ->
        @user = new App.Models.User()
        {email, password} = @credentialStore.load()
        @user.login email, password if (email and password)

    _resetUser: ->
        @user.clear()
        @credentialStore.clear()
        Backbone.BasicAuth.clear()
        @_clearSavedAddresses()
        @user = new App.Models.User()

    _login: (email, password) ->
        console.debug "Logging in user #{email}."
        @_resetUser()
        Backbone.BasicAuth.set email, password
        @credentialStore.save email, password
        @isLoggedIn = true
        @user.set 'email', email
        @events.trigger 'login'

    # Super hack, clears addresses saved by unregistered users. Can't think of a better way right now.
    _clearSavedAddresses: ->
        key = 'AddressCollection'
        addresses = localStorage.getItem key
        return if not addresses
        addresses = addresses.split ','
        for address in addresses
            localStorage.removeItem "#{key}-#{address}"
        localStorage.removeItem key



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

