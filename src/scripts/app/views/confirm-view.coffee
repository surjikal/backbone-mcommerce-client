
class App.Views.Confirm extends App.Views.WizardStep

    template: 'confirm'
    className: 'content confirm-view'

    dependencies: [
        'address'
    ]

    initialize: (options) ->
        super
        console.debug 'Initializing confirm wizard step.'
        {@itemspot} = options
        {@address}  = options.wizardData

        @setView '.order-table', new App.Views.OrderTable {@itemspot}

    beforeNextStep: (done) ->
        done()

    serialize: ->
        console.debug "Serializing confirm view."
        item: @serializeItem()

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

