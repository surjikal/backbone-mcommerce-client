
class App.Models.User extends Backbone.RelationalModel

    relations: [{
        type: Backbone.HasOne
        key: 'account'
        relatedModel: 'App.Models.Account'
        reverseRelation:
            type: Backbone.HasOne
            key: 'user'
    }]

    initialize: (options) ->
        console.debug 'Initializing user model.'
        @set 'account', new App.Models.Account()

    login: (email, password, callbacks = {}) ->

        callbacks.success = _.wrap callbacks.success, (success) =>
            @set 'email', email
            success?()

        App.auth.login email, password, callbacks

    isLoggedIn: ->
        App.auth.isLoggedIn

    parse: (response) ->
        response.objects?[0]

    url: ->
        "#{App.config.urls.api}/users/"


App.Models.User.setup()