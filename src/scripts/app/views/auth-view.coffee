
class App.Views.PasswordWidget extends App.Views.FormView

    template: 'password-widget'

    events:
        'click #toggle-password-display-checkbox': 'togglePasswordDisplay'

    fields:
        'password': '#user-password'

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

    initialize: (options) ->
        console.log 'Initializing auth view.'
        @passwordWidget = new App.Views.PasswordWidget()
        @setView '.password-widget', @passwordWidget
        @next = options.next

        _.defer =>
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
        password = @passwordWidget.getFieldValue 'password'

        validForm = true

        if not email or not password
            return callbacks.error? "Fill in all fields"

        # TODO: validate email address against some regex

        callbacks.success? email, password

    login: (email, password) ->
        $button = @$ 'button'
        $button.addClass 'loading'

        done = ->
            $button.removeClass 'loading'

        App.auth.login email, password,
            incorrect: =>
                @errorAlert "You've supplied invalid credentials. Try again :)"
                done()
            disabled: =>
                @errorAlert "That account has been disabled. Sorry!"
                done()
            error: =>
                @errorAlert "Something went wrong with the login request. Try again :)"
                console.error "Unhandled error during login request:"
                console.error arguments
                done()
            success: =>
                console.debug "Logged in successfully!"
                App.router.navigate @next, {trigger: true} if @next
                done()

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

    initialize: ->

    newUserButtonClicked: ->
        # show login view

    loginButtonClicked: ->
        @setView '.contents', new App.Views.Auth()
        @render()

    cancelButtonClicked: ->
        # go back to itemspot view

    initialize: ->
        super
            contents: new App.Views.LoginOrNewUser()
            title: 'Hello there!'
            instructions: 'Are you a...'



