
class App.Views.ItemSpot extends Backbone.LayoutView

    template: 'itemspot'
    className: 'itemspot-view'

    events:
        'click #buy-button': 'navigateToCheckout'

    navigateToCheckout: ->
        App.router.navigate @model.getCheckoutUrl(), {trigger: true}

    serialize: ->
        @model.toViewJSON()
