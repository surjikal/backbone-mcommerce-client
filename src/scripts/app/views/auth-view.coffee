
class App.Views.PasswordWidget extends App.Views.FormView

    template: 'password-widget'

    events:
        'click #toggle-password-display-checkbox': 'togglePasswordDisplay'

    initialize: (options) ->
        @placeholderText = options.placeholderText or 'Password'

    togglePasswordDisplay: ->
        $passwordFields = @$ 'input.password'
        $passwordFields.val $passwordFields.not('.hidden').val()
        $passwordFields.toggleClass 'hidden'

    serialize: ->
        {@placeholderText}


# TODO: Refactor this so that some code can be shared with registration form.
#
# Callbacks:
# - success:   user was logged in successfully
# - incorrect: credentials are not valid
# - disabled:  the user is disabled
# - error:     generic error
class App.Views.Auth extends App.Views.FormView

    template: 'auth-login'
    className: 'auth-view auth-login-view'

    events:
        'click #login-button': 'submitButtonClicked'
        'keydown input':        'performValidation'

    fields:
        'email':    '#user-email'
        'password': '#user-password'

    initialize: (options) ->
        console.log 'Initializing auth view.'
        @callbacks = options.callbacks or {}
        @setView '.password-widget', new App.Views.PasswordWidget()
        @performValidation()

    submitButtonClicked: (event) ->
        event.preventDefault()
        @validateForm
            error: (message) ->
                @errorAlert message
            success: (email, password) =>
                @login email, password

    performValidation: -> _.defer =>
        $button = @$ 'button'
        @validateForm
            error: (message) ->
                $button.text message
                $button.attr 'disabled', true
            success: (cleanedFields) ->
                $button.text 'Login'
                $button.removeAttr 'disabled'

    validateForm: (callbacks) ->
        email    = @getFieldValue 'email'
        password = @getFieldValue 'password'

        if not email or not password
            return callbacks.error? 'Fill in all fields'

        # TODO: validate email address against some regex

        callbacks.success? email, password

    login: (email, password) ->
        App.auth.login email, password,
            success: (user) =>
                @callbacks.success? user
            incorrect: =>
                @errorAlert "You've supplied invalid credentials. Try again :)"
                (@callbacks.incorrect or @callbacks.error)?()
            disabled: =>
                @errorAlert "That account has been disabled. Sorry!"
                (@callbacks.disabled or @callbacks.error)?()
            error: =>
                @errorAlert "Something went wrong with the login request. Try again :)"
                console.error "Unhandled error during login request."
                console.error arguments
                @callbacks.error?()

    serialize: ->
        buttonText: 'Login'
        instructions: 'Enter your login info below :)'
        user: App.auth.user.toJSON()


class App.Views.Registration extends App.Views.FormView

    template: 'auth-register'
    className: 'auth-view auth-register-view'

    events:
        'click  #register-button': 'submitButtonClicked'
        'keydown input':            'performValidation'

    fields:
        'email':    '#user-email'
        'password': '#user-password'

    initialize: (options) ->
        console.log 'Initializing registration view.'
        @callbacks = options.callbacks or {}
        @initializePasswordWidget()
        @performValidation()

    initializePasswordWidget: ->
        passwordWidget = new App.Views.PasswordWidget
            placeholderText: 'Password (optional)'
        @setView '.password-widget', passwordWidget

    submitButtonClicked: (event) ->
        event.preventDefault()
        @validateForm
            error: (message) ->
                @errorAlert message
            success: (email, password) =>
                return @skipped email if not password
                @register email, password

    performValidation: -> _.defer =>
        $button = @$ 'button'
        @validateForm
            error: (message) ->
                $button.text message
                $button.attr 'disabled', true
            success: (email, password) ->
                text = if password then 'Register and Continue' \
                                   else 'Continue'
                $button.text text
                $button.removeAttr 'disabled'

    validateForm: (callbacks) ->
        email    = @getFieldValue 'email'
        password = @getFieldValue 'password'

        return callbacks.error? 'Please enter your email' if not email

        # TODO: validate email address against some regex

        callbacks.success? email, password

    register: (email, password) ->
        App.auth.register email, password,
            success: (user) =>
                @callbacks.success? user
            alreadyInUse: =>
                @errorAlert "That email address is already in use."
                (@callbacks.alreadyInUse or @callbacks.error)? email, password
            invalid: =>
                @errorAlert 'The email address you entered is invalid.'
                (@callbacks.invalid or @callbacks.error)? email, password
            error: =>
                @errorAlert 'Something went wrong with the registration request. Try again :)'
                console.error "Unhandled error during registration request:\n#{arguments}"
                @callbacks.error? email, password

    # The user didn't enter a password.
    skipped: (email) ->
        App.auth.user.set 'email', email
        @callbacks.skipped? email


class App.Views.LoginOrNewUser extends Backbone.LayoutView

    template: 'login-or-new-user'
    className: 'login-or-new-user-view'


class App.Views.LoginOrNewUserPopup extends App.Views.Popup

    events:
        _.extend {}, App.Views.Popup::events,
            'click #new-user-button':      'newUserButtonClicked'
            'click #existing-user-button': 'loginButtonClicked'

    title: 'Before we begin, are you a...'

    initialize: (options) ->
        super
        @setContents new App.Views.LoginOrNewUser {model: options.model}

    newUserButtonClicked: ->
        console.debug "New user button clicked."
        @callbacks.newUserSuccess? @model

    loginButtonClicked: ->
        console.debug "Login button clicked."
        @setLoginView()
        @render()

    setLoginView: ->
        @setTitle 'Welcome back!'

        callbacks = _.extend @callbacks, success: (user) =>
            @callbacks.loginSuccess? user

        @setContents new App.Views.Auth {@model, callbacks}


class App.Views.LoginPopup extends App.Views.Popup

    title: 'Welcome back!'

    initialize: (options) ->
        super
        @setContents new App.Views.Auth options


class App.Views.RegistrationPopup extends App.Views.Popup

    title: 'Oh! One last thing...'

    initialize: (options) ->
        super
        @setContents new App.Views.Registration options
