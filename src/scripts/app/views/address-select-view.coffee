

class App.Views.AddressSelect extends App.Views.AddressModeView
    template: 'address-select'
    className: 'address-select'

    initialize: (options) ->
        super
        @addressListView = new AddressListView {@collection}
        @setView '.container', @addressListView

    validateForm: (callbacks) ->
        callbacks.success {}

    submitForm: (cleanedFields, callbacks) ->
        address = @addressListView.selectedAddressView.model
        callbacks.success {address}


class AddressListView extends Backbone.LayoutView

    tagName: 'ul'
    className: 'addresses'

    events:
        'vclick .remove': 'removeClicked'

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
        'vclick':         'clicked'
        'vclick .remove': 'removeClicked'

    selected: false

    initialize: (options) ->
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
        $check = @$el.find('.check')
        @selected = selected
        if @selected then $check.show() else $check.hide()

    serialize: ->
        serializedModel = @model.toJSON()
        _.extend serializedModel, {@selected}
