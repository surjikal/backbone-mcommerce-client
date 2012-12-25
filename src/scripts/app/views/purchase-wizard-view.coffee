
class App.Views.PurchaseWizard extends App.Views.Wizard

    className: 'purchase-wizard'

    initialize: (options) ->
        console.debug "Initializing purchase wizard."
        {@itemspot, @done, params} = options
        addresses = App.auth.user.getAddresses()

        App.auth.events.on 'logout', =>
            App.router.navigate @itemspot.getRouterUrl(), {trigger: true}
        , @

        if params.address
            options.wizardData = {address: addresses.get params.address}

        @steps = [
            {
                id: 'shipping'
                title: 'Shipping'
                icon: 'home'
                initialize: (options) => (wizardData) =>
                    new App.Views.Shipping _.extend options, {
                        collection: addresses
                        @itemspot
                        wizardData
                    }
            }
            {
                id: 'billing'
                title: 'Billing'
                icon: 'tag'
                initialize: (options) => (wizardData) =>
                    ViewClass = if App.config.useStripe then App.Views.StripeBilling \
                                                        else App.Views.PaypalBilling
                    new ViewClass  _.extend options, {
                        collection: addresses
                        @itemspot
                        wizardData
                        key: App.config.stripe.key if App.config.useStripe
                    }
            }
            {
                id: 'confirm'
                title: 'Confirm'
                icon: 'user'
                initialize: (options) => (wizardData) =>
                    new App.Views.Confirm _.extend options, {
                        @itemspot
                        wizardData
                    }
            }
        ]

        super

    getStepUrl: (stepId) ->
        "#{@itemspot.getCheckoutUrl()}/#{stepId}"

    onUnmetDependencies: (message) ->
        super
        App.router.navigate "#{@itemspot.getRouterUrl()}", {trigger:true, replace:true}

    completed: (wizardData) ->
        console.debug 'Purchase wizard has been completed.'

        finish = =>
            # TODO: Commit purchase here...
            @done wizardData

        return finish() if App.auth.user.isLoggedIn()
        @_showRegistrationPopup finish

    _showRegistrationPopup: (done) ->
        popup = new App.Views.RegistrationPopup
            model: App.auth.user
            callbacks:
                skipped: =>
                    console.debug "Registration was skipped."
                    popup.close()
                    done()
                success: =>
                    console.debug "Registration was a success."
                    popup.close()
                    done()
        App.views.main.showPopup popup

    cleanup: ->
        console.debug "Cleaning up purchase wizard view."
        App.auth.events.off null, null, @
