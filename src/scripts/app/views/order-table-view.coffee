
class App.Views.OrderTable extends Backbone.LayoutView

    template:  'order-table'
    className: 'order-table-view'

    initialize: (options) ->
        {@itemspot} = options

    getCosts: ->
        item  = parseFloat (@itemspot.get 'itemPrice')
        tax   = item * 0.13
        total = tax  + item
        {item, tax, total, shipping: 'free!'}

    serialize: ->
        costs: @getCosts()
        item:  @itemspot.toViewJSON().item
