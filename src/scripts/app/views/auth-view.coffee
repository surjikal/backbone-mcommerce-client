
class App.Views.PasswordWidget extends App.Views.FormView

    template: 'password-widget'

    events:
        'click #toggle-password-display-checkbox': 'togglePasswordDisplay'

    togglePasswordDisplay: ->
        $passwordFields = @$ 'input.password'
        $passwordFields.val $passwordFields.not('.hidden').val()
        $passwordFields.toggleClass 'hidden'


# TODO: Refactor this so that some code can be shared with registration form.
class App.Views.Auth extends App.Views.FormView

    template: 'auth'
    className: 'content auth'

    events:
        'click button':  'submitButtonClicked'
        'keydown input': 'performValidation'

    fields:
        'email': '#user-email'
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
                $button.text 'Continue'
                $button.attr 'disabled', false

    validateForm: (callbacks) ->
        email    = @getFieldValue 'email'
        password = @getFieldValue 'password'

        if not email or not password
            return callbacks.error? "Fill in all fields"

        # TODO: validate email address against some regex

        callbacks.success? email, password

    login: (email, password) ->
        App.auth.login email, password,
            incorrect: =>
                @errorAlert "You've supplied invalid credentials. Try again :)"
                (@callbacks.incorrect or @callbacks.error)?()
            disabled: =>
                @errorAlert "That account has been disabled. Sorry!"
                (@callbacks.disabled or @callbacks.error)?()
            error: =>
                @errorAlert "Something went wrong with the login request. Try again :)"
                console.error "Unhandled error during login request:\n#{arguments}"
                @callbacks.error?()
            success: (user) =>
                console.debug "Logged in successfully!"
                @callbacks.success? user  # FIXME: For now..

    serialize: ->
        buttonText: 'Login'
        instructions: 'Enter your login info below :)'


class App.Views.LoginOrNewUser extends Backbone.LayoutView

    template: 'login-or-new-user'
    className: 'login-or-new-user'


class App.Views.LoginOrNewUserPopup extends App.Views.Popup

    events:
        'click #new-user-button':      'newUserButtonClicked'
        'click #existing-user-button': 'loginButtonClicked'
        'click #cancel-button':        'cancelButtonClicked'

    initialize: (options) ->
        @callbacks = options.callbacks
        super
            title: 'Yo! Before we begin, are you a...'
            contents: new App.Views.LoginOrNewUser()

    newUserButtonClicked: ->
        console.debug "New user button clicked."
        @callbacks.newUserSuccess? App.models.user

    loginButtonClicked: ->
        console.debug "Login button clicked."
        @setTitle 'Welcome back!'

        _.extend @callbacks,
            success: (user) =>
                @callbacks.loginSuccess? user

        @setContents new App.Views.Auth {@callbacks}
        @render()

    cancelButtonClicked: ->
        # go back to itemspot view
