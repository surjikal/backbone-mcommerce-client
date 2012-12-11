
class App.Views.Confirm extends App.Views.WizardStep

    template: 'confirm'
    className: 'content confirm-view'

    dependencies: [
        'address'
    ]

    initialize: (options) ->
        super options
        console.debug 'Initializing confirm wizard step.'
        {@itemspot} = options
        {@address}  = options.wizardData

    beforeNextStep: (done) ->
        done()

    getPricingInfo: ->
        shipping: 0
        tax: 10
        total: 12

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

