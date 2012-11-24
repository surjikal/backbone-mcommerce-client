
class App.Views.ItemSpot extends Backbone.LayoutView

    template: 'itemspot'
    className: 'content item'

    events:
        'vclick button': 'navigateToCheckout'

    getCheckoutUrl: ->
        "#{@model.getRouterUrl()}/checkout"

    navigateToCheckout: ->
        App.router.navigate @getCheckoutUrl(), {trigger: true}

    serialize: ->
        @model.toViewJSON()
