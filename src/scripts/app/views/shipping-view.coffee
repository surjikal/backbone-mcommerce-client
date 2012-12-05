
class App.Views.Shipping extends App.Views.WizardStep

    template: 'shipping'
    className: 'content address-list'

    currentAddressMode: null
    currentAddressModeView: null
    addressModeSetters: null

    events:
        'vclick #toggle-address-mode': 'toggleAddressMode'
        'vclick #wizard-next-step':    'wizardNextStepClicked'
        'keydown input':              'performValidation'

    initialize: (options) ->
        super
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
                $button.attr 'disabled', false

    wizardNextStepClicked: (event) ->
        event.preventDefault()
        return false if @pending

        @enablePending()
        @currentAddressModeView.validateForm
            success: (cleanedFields) =>
                addressesWasEmpty =  @collection.isEmpty()
                @currentAddressModeView.submitForm cleanedFields,
                    error: =>
                        console.debug "Form submit failed."
                        @disablePending()
                    success: (address) =>
                        @disablePending()
                        @setAddressSelectMode() if addressesWasEmpty
                        @completed address
        return false

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
