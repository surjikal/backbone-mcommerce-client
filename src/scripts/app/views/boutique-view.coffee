
class App.Views.Boutique extends Backbone.LayoutView

    template: 'boutique'
    className: 'content boutique-view'

    serialize: ->
        serializedItemSpots = @serializeItemSpotModels()

        name: @model.get 'code'

        itemSpotRow: [
            {itemSpots: serializedItemSpots[0..1]}
            {itemSpots: serializedItemSpots[2..3]}
            {itemSpots: serializedItemSpots[4..5]}
            {itemSpots: serializedItemSpots[6..7]}
        ]

    serializeItemSpotModels: ->
        itemSpots = @model.get 'itemSpots'
        itemSpots.map (itemSpot) =>
            itemSpot.toViewJSON()