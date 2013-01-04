

class App.Views.AddressSelect extends App.Views.AddressModeView
    template: 'address-select'

    className: 'address-select'

    initialize: (options) ->
        super
        @addressListView = new AddressListView {@collection}
        @setView @addressListView

    validateForm: (callbacks) ->
        callbacks.success {}

    submitForm: (cleanedFields, callbacks) ->
        address = @addressListView.selectedAddressView.model
        callbacks.success {address}


class AddressListView extends Backbone.LayoutView

    tagName: 'ul'
    className: 'addresses'

    events:
        'click .remove': 'removeClicked'

    selectedAddressView: null

    selectAddressView: (addressView) ->
        @selectedAddressView?.deselect()
        @selectedAddressView = addressView
        @selectedAddressView.select()

    removeClicked: ->
        @render()

    beforeRender: ->
        @collection.each (address, index) =>
            firstAddress = index is 0

            addressView = new AddressListItemView
                parent: @
                selected: firstAddress
                model: address

            @selectedAddressView = addressView if firstAddress
            @insertView addressView


class AddressListItemView extends Backbone.LayoutView
    template: 'address'

    tagName: 'li'
    className: 'address'

    events:
        'click':         'clicked'
        'click .remove': 'removeClicked'

    selected: false

    initialize: (options) ->
        @parent = options.parent
        @select() if options.selected

    clicked: ->
        return @toggleRemoveButton() if @isSelected()
        _.defer => @parent.selectAddressView @

    hideRemoveButton: ->
        @$el.find('.remove').hide()

    toggleRemoveButton: ->
        @$el.find('.remove').toggle()

    removeClicked: (event) ->
        @model.destroy()
        true

    select: ->
        @setSelected true

    deselect: ->
        @setSelected false
        @hideRemoveButton()

    isSelected: ->
        @selected

    setSelected: (selected) ->
        @selected = selected
        @render()

    serialize: ->
        serializedModel = @model.toJSON()
        _.extend serializedModel, {@selected}
