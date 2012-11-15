
class App.Layouts.Login extends Backbone.Layout

    template: 'login'
    className: 'register'

    initialize: ->
        @setView '.password-widget', new App.Views.PasswordWidget()
