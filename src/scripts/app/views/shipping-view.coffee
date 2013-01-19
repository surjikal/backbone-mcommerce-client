
class App.Views.Shipping extends App.Views.WizardStep

    template: 'shipping'
    className: 'shipping-view'

    currentAddressMode: null
    currentAddressModeView: null
    addressModeSetters: null

    events:
        _.extend {}, App.Views.WizardStep::events,
            'click #toggle-address-mode': 'toggleAddressMode'
            'click #show-login-popup':    'showLoginPopup'
            'keydown input':              'performValidation'

    initialize: (options) ->
        super

        {itemspot} = options

        @collection.on 'remove', =>
            @render() if @collection.isEmpty()

        @addressModeSetters =
            'create': @setAddressCreateView
            'select': @setAddressSelectView

        @setAddressSelectMode()

        refresh = ->
            App.router.navigate itemspot.getCheckoutUrl(), {trigger:true}

        App.auth.events.on 'login', refresh, @

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
        super

        if @collection.isEmpty()
            console.debug "Addresses empty."
            @setAddressCreateMode()

        @addressModeSetters[@currentAddressMode].call @

    toggleAddressMode: ->
        @currentAddressMode = @getNextAdddressMode()
        @render()

    setAddressCreateMode: ->
        @currentAddressMode = 'create'
        @$('#toggle-address-mode').text 'cancel'

    setAddressSelectMode: ->
        @currentAddressMode = 'select'
        @$('#toggle-address-mode').text '+ address'

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
        @performValidation()

    showLoginPopup: ->
        App.views.main.showPopup new App.Views.LoginPopup callbacks:
            success: =>
                @render()
                App.views.main.removePopup()

    serialize: ->
        showModeToggleButton: not @collection.isEmpty()
        toggleButtonText: if @currentAddressMode is 'create' then 'cancel' else '+ address'
        user: App.auth.user.toJSON() if App.auth.user.isLoggedIn()

    close: ->
        console.debug "Cleaning up shipping view."
        App.auth.events.off null, null, @
