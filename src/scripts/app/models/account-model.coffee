
class App.Models.Account extends Backbone.RelationalModel

    defaults:
        firstName: null
        lastName:  null
        addresses: null

    relations: [{
        type: Backbone.HasMany
        key: 'addresses'
        relatedModel: 'App.Models.Address'
    }]

    initialize: (options) ->
        console.debug 'Initializing user model.'
        @addresses = new App.Collections.Address()

    isLoggedIn: ->
        App.auth.isLoggedIn


App.Models.Account.setup()
