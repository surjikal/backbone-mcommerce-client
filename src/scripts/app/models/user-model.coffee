
class App.Models.User extends Backbone.RelationalModel

    relations: [
        type: Backbone.HasOne
        key: 'account'
        relatedModel: 'App.Models.Account'
        reverseRelation:
            type: Backbone.HasOne
            key: 'user'
    ]

    initialize: (options) ->
        console.debug 'Initializing user model.'
        @set 'account', new App.Models.Account()

    getAddresses: ->
        (@get 'account').get 'addresses'

    login: (email, password, callbacks = {}) ->
        App.auth.login email, password, callbacks

    isLoggedIn: ->
        App.auth.isLoggedIn

    url: ->
        "#{App.config.urls.api}/users/"


App.Models.User.setup()