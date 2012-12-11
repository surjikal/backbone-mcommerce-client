
class App.Views.ItemSpot extends Backbone.LayoutView

    template: 'itemspot'
    className: 'content itemspot-view'

    events:
        'vclick #checkout-button': 'navigateToCheckout'

    navigateToCheckout: ->
        App.router.navigate @model.getCheckoutUrl(), {trigger: true}

    serialize: ->
        @model.toViewJSON()
