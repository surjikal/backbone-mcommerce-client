
class App.Auth

    isLoggedIn: false

    constructor: ->
        @events = _.extend {}, Backbone.Events

        # TODO: Switch to native secure storage in phonegap.
        @credentialStore = new App.Controllers.LocalStorageCredentialStore()

    initialize: ->
        @_initializeUser()

    # Callbacks
    # - success:   the credentials are valid
    # - incorrect: the credentials are not valid (i.e. user doesn't exist, bad email/pw combo)
    # - invalid:   the parameters supplied we not valid (i.e. missing '@' in email address)
    # - disabled:  the account associated to the credentials has been disabled
    # - error:     there was an error communicating with the server
    login: (email, password, {success, incorrect, invalid, disabled, error} = {}) ->
        App.api.auth.validate email, password, {incorrect, invalid, disabled, error, success: =>
            @_resetUser()
            @_login email, password
            success? @user
        }

    # Callbacks
    # - success:         the user was created successfully
    # - invalid:         the parameters supplied we not valid (i.e. bad email address)
    # - alreadyInUse:    the email supplied belongs to an existing account
    # - conversionError: there was an error while trying to convert the anon user account
    # - error:           there was an error communicating with the server
    register: (email, password, {success, invalid, alreadyInUse, conversionError, error} = {}) ->
        App.api.auth.register email, password, {invalid, alreadyInUse, error, success: =>
            console.debug "User '#{email}' was registered successfully"
            @_login email, password
            @_convertAnonymousUser {error:conversionError, success: =>
                console.debug "Converted anonymous user successfully."
                @credentialStore.save email, password
                success? @user
            }
        }

    logout: ->
        console.debug "Logging out user."
        @_resetUser()
        @_initializeAnonymousUser()
        @isLoggedIn = false
        @token = null
        @events.trigger 'logout'

    _login: (email, password) ->
        console.debug "Logging in user '#{email}'."
        @token = @_makeBasicAuthToken email, password
        Backbone.BasicAuth.set email, password
        @credentialStore.save email, password
        @isLoggedIn = true
        @user.set 'email', email
        @events.trigger 'login'

    _initializeUser: ->
        @user = new App.Models.User()
        {email, password} = @credentialStore.load()
        return @_initializeAnonymousUser() if not email or not password
        @_initializeRegisteredUser email, password

    _initializeRegisteredUser: (email, password) ->
        console.debug "Initializing registered user '#{email}'."
        @_login email, password

    _initializeAnonymousUser: (email) ->
        console.debug "Initializing anonymous user."
        @user.set 'email', email if email
        addresses = @user.getAddresses()
        addresses.localStorage = new Backbone.LocalStorage 'AddressCollection'

    # Callbacks:
    # - success: the sync was successful
    # - error:   the sync failed
    _convertAnonymousUser: ({success, error} = {}) ->
        addresses = @user.getAddresses()
        addressesCopy = new App.Collections.Address()
        (@user.get 'account').set 'addresses', addressesCopy

        # FIXME: This is nasty, but I don't know how to POST to a address list endpoint!
        #        So instead, I just create all of the addresses in parallel.
        makeAddressCreateCallback = (address) -> (callback) ->
            serialized = address.toJSON()
            delete serialized.id
            addressesCopy.create serialized,
                error: (model, error)->
                    callback error
                success: (model) ->
                    callback null, model

        async.parallel (addresses.map makeAddressCreateCallback), (err, results) ->
            return error? err if err
            success?()

    _resetUser: ->
        @user.clear()
        @_resetPersistedData()
        @user = new App.Models.User()

    _resetPersistedData: ->
        Backbone.BasicAuth.clear()
        @credentialStore.clear()
        localStorage.clear()

    _makeBasicAuthToken: (username, password) ->
        btoa "#{username}:#{password}"


class App.Controllers.LocalStorageCredentialStore

    save: (email, password) ->
        localStorage.setItem 'email',    email
        localStorage.setItem 'password', password

    load: ->
        email:    localStorage.getItem 'email'
        password: localStorage.getItem 'password'

    clear: ->
        localStorage.removeItem 'email'
        localStorage.removeItem 'password'

