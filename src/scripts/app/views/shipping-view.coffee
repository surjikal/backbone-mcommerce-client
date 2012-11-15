
class App.Views.Shipping extends App.Views.WizardStep

    template: 'shipping'
    className: 'content address-list'

    currentAddressMode: null
    currentAddressModeView: null
    addressModeSetters: null

    events:
        'click #toggle-address-mode': 'toggleAddressMode'
        'click #wizard-next-step':    'wizardNextStepClicked'
        'keydown input':              'performValidation'

    initialize: (options) ->
        super options
        @addresses = options.addresses

        @addresses.on 'remove', =>
            @render() if @addresses.isEmpty()

        @addressModeSetters =
            'create': @setAddressCreateView
            'select': @setAddressSelectView

        @setAddressSelectMode()

    performValidation: (event) -> _.defer =>
        $button = $('#wizard-next-step')
        @currentAddressModeView.validateForm

            error: (message) ->
                $button.text message
                $button.attr 'disabled', true

            success: (cleanedFields) ->
                $button.text 'Continue'
                $button.attr 'disabled', false

    wizardNextStepClicked: (event) ->
        event.preventDefault()

        if not @pending
            @enablePending() 
            @currentAddressModeView.validateForm

                error: ->
                    console.error "Form validation error."

                success: (cleanedFields) =>
                    addressesWasEmpty =  @addresses.isEmpty()
                    @currentAddressModeView.submitForm cleanedFields,
                        error: =>
                            console.debug "Form submit failed."
                            @disablePending()
                        success: (address) =>
                            @disablePending()
                            @setAddressSelectMode() if addressesWasEmpty
                            @completed {address}
        return false

    enablePending: ->
        @pendingTimer = setTimeout( =>
            @pending = true
            $button = $('#wizard-next-step')
            $button.addClass 'loading'
        , 500)

    disablePending: ->
        clearTimeout @pendingTimer
        @pending = false
        $button = $('#wizard-next-step')
        $button.removeClass 'loading'

    beforeRender: ->
        if @addresses.isEmpty()
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
        @setAddressView new App.Views.AddressCreate {@addresses}

    setAddressSelectView: ->
        console.debug 'Setting address select view.'
        @setAddressSelectMode()
        @setAddressView new App.Views.AddressSelect {@addresses}

    setAddressView: (addressModeView) ->
        @currentAddressModeView = addressModeView
        @setView '#address-mode', addressModeView
        _.defer =>
            @performValidation()
