
class App.Views.ItemSpot extends Backbone.LayoutView

    template: 'itemspot'
    className: 'content item'

    events:
        'click button': 'navigateToCheckout'

    getCheckoutUrl: ->
        "#{@model.getRouterUrl()}/checkout"

    navigateToCheckout: ->
        App.router.navigate @getCheckoutUrl(), {trigger: true}

    serialize: ->
        @model.toViewJSON()
