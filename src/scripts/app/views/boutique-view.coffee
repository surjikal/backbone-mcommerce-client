
class App.Views.Boutique extends Backbone.LayoutView

    template: 'boutique'
    className: 'content boutique-view'

    serialize: ->
        serializedItemSpots = @serializeItemSpotModels()

        name: @model.get 'code'
        itemSpotRow: [
            {itemSpots: serializedItemSpots[0..2]}
            {itemSpots: serializedItemSpots[3..5]}
            {itemSpots: serializedItemSpots[6..8]}
        ]

    serializeItemSpotModels: ->
        itemSpots = @model.get 'itemSpots'
        itemSpots.map (itemSpot) =>
            itemSpot.toViewJSON()