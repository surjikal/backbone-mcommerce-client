
class App.Models.Boutique extends Backbone.RelationalModel

    idAttribute: 'code'

    defaults:
        code: null

    relations: [
        type: Backbone.HasMany
        key: 'itemSpots'
        relatedModel: 'App.Models.ItemSpot'
        collectionType: 'App.Collections.ItemSpot'
        reverseRelation: {
            key: 'boutique',
            includeInJSON: 'code'
        }
    ]

    getItemSpotFromIndex: (index) ->
        itemSpots = @get 'itemSpots'
        itemSpots.sort()
        itemSpots.at index-1

    getRouterUrl: ->
        "/boutiques/#{@id}"

    urlRoot: ->
        "#{App.config.urls.api}/boutiques"


App.Models.Boutique.setup()