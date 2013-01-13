
class App.Collections.Address extends App.Collections.Base

    model: App.Models.Address

    initialize: ->
        console.debug 'Initializing address collection.'
        App.auth.events.on 'logout', @onLogout, @

    onLogout: =>
        @reset()
        App.auth.events.off null, null, @

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
