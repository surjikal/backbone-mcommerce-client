
class App.Collections.Address extends Backbone.Collection

    model: App.Models.Address

    parse: (response) ->
        response.objects

    url: ->
        "#{App.config.urls.api}/addresses/"