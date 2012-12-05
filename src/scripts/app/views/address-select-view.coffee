

class App.Views.AddressSelect extends App.Views.AddressModeView
    template: 'address-select'
    className: 'address-select'

    events:
        'vclick .remove': 'removeClicked'

    selectedAddressView: null

    selectAddressView: (addressView) ->
        @selectedAddressView?.deselect()
        @selectedAddressView = addressView
        @selectedAddressView.select()

    validateForm: (callbacks) ->
        callbacks.success {}

    submitForm: (cleanedFields, callbacks) ->
        callbacks.success @selectedAddressView.model

    removeClicked: ->
        # The removal of the address model is done by the list item itself.
        @render()

    beforeRender: ->
        @collection.each (address, index) =>
            firstAddress = index is 0

            addressView = new AddressListItemView
                parent: @
                selected: firstAddress
                model: address

            if firstAddress
                @selectedAddressView = addressView

            @insertView '.addresses', addressView


class AddressListItemView extends Backbone.LayoutView
    template: 'address'
    tagName: 'li'
    className: 'address'

    events:
        'vclick':         'clicked'
        'vclick .remove': 'removeClicked'

    selected: false

    keep: true # This makes things work.. WTF

    initialize: (options) ->
        console.debug 'Initializing address view.'
        @parent = options.parent
        @select() if options.selected

    clicked: ->
        if @isSelected()
            @toggleRemoveButton()
        else
            @parent.selectAddressView @

    hideRemoveButton: ->
        @$el.find('.remove').hide()

    toggleRemoveButton: ->
        @$el.find('.remove').toggle()

    removeClicked: ->
        @model.destroy()
        @remove()
        true

    select: ->
        @setSelected true

    deselect: ->
        @setSelected false
        @hideRemoveButton()

    isSelected: ->
        @selected

    setSelected: (selected) ->
        $check = @$el.find('.check')
        @selected = selected
        if @selected then $check.show() else $check.hide()

    serialize: ->
        serializedModel = @model.toJSON()
        _.extend serializedModel, {@selected}
