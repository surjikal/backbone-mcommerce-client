
class App.Views.ItemSpot extends App.Views.FormView

    template: 'itemspot'
    className: 'content item'

    events:
        _.extend {}, App.Views.FormView::events,
            'click button': 'navigateToCheckout'

    navigateToCheckout: ->
        @enablePending 'button'
        App.router.navigate @model.getCheckoutUrl(), {trigger: true}

    serialize: ->
        @model.toViewJSON()
