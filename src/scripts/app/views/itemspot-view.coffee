
class App.Views.ItemSpot extends App.Views.FormView

    template: 'itemspot'
    className: 'itemspot-view'

    events:
        'click #buy-button': 'navigateToCheckout'

    initialize: ->
        $(window).on 'resize', _.debounce =>
            @onResize()
        , 10

    navigateToCheckout: ->
        @enablePending 'button'
        App.router.navigate @model.getCheckoutUrl(), {trigger: true}

    serialize: ->
        @model.toViewJSON()

    afterRender: ->
        $img = @$('.item-images img')
        $img.on 'load', => @_adjustLayout()

    onResize: ->
        @_adjustLayout()

    _adjustLayout: ->

        do _adjustItemInfoLayout = ->
            $itemInfo   = @$('.item-info')
            $itemImages = @$('.item-images')
            $itemInfo.css 'top', $itemImages.height()

        do _adjustItemDetailsLayout = ->
            $itemDetails = @$('.item-info .item-details')
            $header      = @$('.item-info header')
            $itemDetails.css 'top', $header.height()
