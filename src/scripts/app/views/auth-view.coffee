
class App.Views.PasswordWidget extends App.Views.FormView

    template: 'password-widget'

    events:
        'click #toggle-password-display-checkbox': 'togglePasswordDisplay'

    fields:
        'password': '#user-password'

    togglePasswordDisplay: ->
        $passwordFields = @$el.find 'input.password'
        $passwordFields.val $passwordFields.not('.hidden').val()
        $passwordFields.toggleClass 'hidden'


class App.Views.Auth extends App.Views.FormView

    template: 'auth'
    className: 'content auth'

    events:
        'click #login-button': 'loginButtonClicked'

    fields:
        'email': '#user-email'

    initialize: (options) ->
        console.log 'Initializing auth view.'
        @passwordWidget = new App.Views.PasswordWidget()
        @setView '.password-widget', @passwordWidget
        @next = options.next

    loginButtonClicked: ->
        email = @getFieldValue 'email'
        password = @passwordWidget.getFieldValue 'password'
        validForm = true

        if not email
            validForm = false
            @setFieldError 'email'

        if not password
            validForm = false
            @passwordWidget.setFieldError 'password'

        if not validForm
            return @errorAlert "Please fill in all the fields in this form :)"

        @login email, password

    login: (email, password) ->
        App.auth.login email, password,
            incorrect: =>
                @errorAlert "You've supplied invalid credentials. Try again :)"
            disabled: =>
                @errorAlert "That account has been disabled. Sorry!"
            error: =>
                @errorAlert "Something went wrong with the login request. Try again :)"
                console.error "Unhandled error during login request:"
                console.error arguments
            success: =>
                console.debug "Logged in successfully!"
                App.router.navigate @next, {trigger: true} if @next

    register: (email, password) ->
        # user = new App.Models.User {username, password}



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



