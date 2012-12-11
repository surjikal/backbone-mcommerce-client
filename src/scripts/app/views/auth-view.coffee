
class App.Views.PasswordWidget extends App.Views.FormView

    template: 'password-widget'

    events:
        'vclick #toggle-password-display-checkbox': 'togglePasswordDisplay'

    initialize: (options) ->
        @placeholderText = options.placeholderText or 'Password'

    togglePasswordDisplay: ->
        $passwordFields = @$ 'input.password'
        $passwordFields.val $passwordFields.not('.hidden').val()
        $passwordFields.toggleClass 'hidden'

    serialize: ->
        {@placeholderText}


# TODO: Refactor this so that some code can be shared with registration form.
class App.Views.Auth extends App.Views.FormView

    template: 'auth'
    className: 'content auth'

    events:
        'vclick #login-button': 'submitButtonClicked'
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
            success: ->
                $button.text 'Login'
                $button.attr 'disabled', false

    validateForm: (callbacks) ->
        email    = @getFieldValue 'email'
        password = @getFieldValue 'password'

        if not email or not password
            return callbacks.error? 'Fill in all fields'

        # TODO: validate email address against some regex

        callbacks.success? email, password

    login: (email, password) ->
        @model.login email, password,
            success: =>
                console.debug "Logged in successfully!"
                @callbacks.success? @model
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
        user: @model.toJSON()


class App.Views.Registration extends App.Views.FormView

    template: 'registration'
    className: 'auth'

    events:
        'vclick  #register-button': 'submitButtonClicked'
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
                $button.attr 'disabled', false

    validateForm: (callbacks) ->
        email    = @getFieldValue 'email'
        password = @getFieldValue 'password'

        return callbacks.error? 'Please enter your email' if not email

        # TODO: validate email address against some regex

        callbacks.success? email, password

    register: (email, password) ->
        App.api.auth.register email, password,
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
            success: =>
                @callbacks.success?()

    # The user didn't enter a password.
    skipped: (email) ->
        @model.set 'email', email
        @callbacks.skipped? email


class App.Views.LoginOrNewUser extends Backbone.LayoutView

    template: 'login-or-new-user'
    className: 'login-or-new-user'


class App.Views.LoginOrNewUserPopup extends App.Views.Popup

    events:
        _.extend {}, App.Views.Popup::events,
            'vclick #new-user-button':      'newUserButtonClicked'
            'vclick #existing-user-button': 'loginButtonClicked'

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


class App.Views.RegistrationPopup extends App.Views.Popup

    title: 'Oh! One last thing...'

    initialize: (options) ->
        super
        @setContents new App.Views.Registration options
