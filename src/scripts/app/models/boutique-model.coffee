
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
        itemSpots.at index-1

    # addItemSpot: (itemSpot) ->
    #     itemSpots = @get 'itemSpots'
    #     itemSpots = @createItemSpotCollection() if not itemSpots
    #     boutiqueCode = @get 'id'
    #     itemSpot.set 'boutiqueCode', boutiqueCode

    # createItemSpotCollection: ->
    #     itemSpots = new App.Collections.ItemSpot()
    #     @set 'itemSpots', itemSpots
    #     itemSpots

    routerUrl: ->
        "/boutiques/#{@id}"

    url: ->
        "#{App.config.urls.api}/boutiques/#{@id}/"


App.Models.Boutique.setup()