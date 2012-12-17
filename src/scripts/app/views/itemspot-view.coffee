
class App.Views.ItemSpot extends Backbone.LayoutView

    template: 'itemspot'
    className: 'content item'

    events:
        'click button': 'navigateToCheckout'

    navigateToCheckout: ->
        App.router.navigate @model.getCheckoutUrl(), {trigger: true}

    serialize: ->
        @model.toViewJSON()
