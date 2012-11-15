
class App.Views.ItemSpot extends Backbone.LayoutView

    template: 'itemspot'
    className: 'content item'

    events:
        'click button': 'navigateToCheckout'

    getCheckoutUrl: ->
        boutiqueCode = @getBoutiqueCode()
        index = @model.get 'index'
        "/boutiques/#{boutiqueCode}/items/#{index}/checkout"

    getBoutiqueCode: ->
        boutique = @model.get 'boutique'
        boutique.get 'code'

    navigateToCheckout: ->
        App.router.navigate @getCheckoutUrl(), {trigger: true}

    serialize: ->
        console.log @model
        item = @model.get 'item'
        _.extend @model.toJSON(),
            image: "http://localhost:9000/static/images/#{item.image}"
