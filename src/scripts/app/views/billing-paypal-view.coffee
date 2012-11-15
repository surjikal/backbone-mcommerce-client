
class App.Views.PaypalBilling extends Backbone.LayoutView

    template: 'billing-paypal'
    className: 'content billing-paypal'

    # afterRender: ->

    #     opts =
    #         lines: 9
    #         length: 2
    #         width: 3
    #         radius: 7
    #         corners: 1
    #         rotate: 0
    #         color: '#000'
    #         speed: 1
    #         trail: 60
    #         shadow: false
    #         hwaccel: true
    #         className: 'spinner'
    #         zIndex: 2e9
    #         top: 'auto'
    #         left: 'auto'

    #     target = @$el.find('button')
    #     spinner = new Spinner(opts).spin(target)
    #     target.append spinner.el
    #     console.debug target

    #     