
class App.Views.Shipping extends App.Views.WizardStep

    template: 'shipping'
    className: 'content address-list'

    currentAddressMode: null
    currentAddressModeView: null
    addressModeSetters: null

    events:
        _.extend {}, App.Views.WizardStep::events,
            'click #toggle-address-mode': 'toggleAddressMode'
            'keydown input':               'performValidation'

    initialize: (options) ->
        super options

        @collection.on 'remove', =>
            @render() if @collection.isEmpty()

        @addressModeSetters =
            'create': @setAddressCreateView
            'select': @setAddressSelectView

        @setAddressSelectMode()

    performValidation: (event) -> _.defer =>
        $button = @$ '#wizard-next-step'
        @currentAddressModeView.validateForm
            error: (message) ->
                $button.text message
                $button.attr 'disabled', true
            success: (cleanedFields) ->
                $button.text 'Continue'
                $button.removeAttr 'disabled'

    beforeNextStep: (done) ->
        return if @pending

        @enablePending()
        @currentAddressModeView.validateForm
            success: (cleanedFields) =>
                #addressesWasEmpty = @collection.isEmpty()
                @currentAddressModeView.submitForm cleanedFields,
                    error: =>
                        @disablePending()
                    success: (data) =>
                        @disablePending()
                        # @setAddressSelectMode() if addressesWasEmpty
                        @_addUrlParameter 'address', (data.address.get 'id')
                        done data

    beforeRender: ->
        if @collection.isEmpty()
            console.debug "Addresses empty."
            @setAddressCreateMode()

        @addressModeSetters[@currentAddressMode].call @

    toggleAddressMode: ->
        @currentAddressMode = @getNextAdddressMode()
        @render()

    setAddressCreateMode: ->
        @currentAddressMode = 'create'

    setAddressSelectMode: ->
        @currentAddressMode = 'select'

    getNextAdddressMode: ->
        if @currentAddressMode is 'create' then 'select' else 'create'

    setAddressCreateView: ->
        console.debug 'Setting address create view.'
        @setAddressCreateMode()
        @setAddressView new App.Views.AddressCreate {@collection}

    setAddressSelectView: ->
        console.debug 'Setting address select view.'
        @setAddressSelectMode()
        @setAddressView new App.Views.AddressSelect {@collection}

    setAddressView: (addressModeView) ->
        @currentAddressModeView = addressModeView
        @setView '#address-mode', addressModeView
        _.defer =>
            @performValidation()
