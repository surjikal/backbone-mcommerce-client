
class App.Views.Boutique extends Backbone.LayoutView

    template: 'boutique'
    className: 'content ad'

    serialize: ->
        serializedItemSpots = @serializeItemSpotModels()

        name: @model.get 'code'
        itemSpotRow: [
            {itemSpots: serializedItemSpots[0..2]}
            {itemSpots: serializedItemSpots[3..5]}
            {itemSpots: serializedItemSpots[6..8]}
        ]

    serializeItemSpotModels: ->
        code      = @model.get 'code'
        itemSpots = @model.get 'itemSpots'

        itemSpots.map (itemSpot) =>
            @serializeItemSpotModel code, itemSpot

    serializeItemSpotModel: (boutiqueCode, itemSpot) ->
        serializedItemSpot = itemSpot.toJSON()
        serializedItemSpot.url = @serializeItemSpotUrl boutiqueCode, itemSpot
        item = itemSpot.get 'item'
        # FIXME: Bad image location
        serializedItemSpot.image = "http://localhost:9000/static/images/#{item.image}"
        serializedItemSpot

    serializeItemSpotUrl: (boutiqueCode, itemSpot) ->
        index = itemSpot.get 'index'
        "/boutiques/#{boutiqueCode}/items/#{index}"
