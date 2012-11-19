
class App.Collections.Address extends Backbone.Collection

    model: App.Models.Address

    initialize: ->
        App.auth.events.on 'logout', @onLogout

    onLogout: =>
        @reset()

    parse: (response) ->
        response.objects

    fetch: (callbacks = {}) ->
        super
            success: callbacks.success
            error: (addresses, response) ->
                callback = switch response.status
                    when 401 then callbacks.unauthorized
                    else          callbacks.error
                callback? addresses, response

    url: ->
        "#{App.config.urls.api}/addresses/"