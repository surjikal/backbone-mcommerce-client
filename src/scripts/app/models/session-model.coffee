
class App.Models.Session extends Backbone.Model

    defaults:
        token: null
        userId: null

    initialize: ->
        @load()

    authenticated: ->
        Boolean(@get 'token')

    # Saves session information to cookie
    save: (authHash)->
        $.cookie 'userId', authHash.id
        $.cookie 'token', authHash.accessToken

    # Loads session information from cookie
    load: ->
        @set
          userId: $.cookie 'userId'
          accessToken: $.cookie 'accessToken'