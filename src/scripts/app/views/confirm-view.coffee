
class App.Views.Confirm extends App.Views.WizardStep

    template: 'confirm'
    className: 'content confirm'

    dependencies: [
        'address'
    ]

    initialize: (options) ->
        super
        console.debug 'Initializing confirm wizard step.'
        {@itemspot} = options
        {@address}  = options.wizardData

    beforeNextStep: (done) ->
        done()

    getPricingInfo: ->
        item  = parseFloat (@itemspot.get 'itemPrice')
        tax   = item * 0.13
        total = tax + item
        {item, tax, total, shipping: 'free!'}

    serialize: ->
        console.debug "Serializing confirm view."
        item: @serializeItem()
        bill: @getPricingInfo()

    serializeItem: ->
        itemspot = @itemspot.toViewJSON()
        name: itemspot.item.name
        price: itemspot.itemPrice


# API inputs:
# - country
# - postal code
# - price


# API returns:
# - shipping
# - tax
# - total

