
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

    url: ->
        "#{App.config.urls.api}/addresses/"
