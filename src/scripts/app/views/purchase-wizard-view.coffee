
class App.Views.PurchaseWizard extends App.Views.Wizard

    className: 'purchase-wizard'

    initialize: (options) ->
        console.debug "Initializing purchase wizard."
        {@itemspot, user, params} = options
        addresses = user.getAddresses()

        App.auth.events.on 'logout', =>
            App.router.navigate @itemspot.getRouterUrl(), {trigger: true}

        if params.address
            options.wizardData = {address: addresses.get params.address}

        @steps = [
            {
                id: 'shipping'
                title: '1. Shipping'
                icon: 'house'
                initialize: (options) => (wizardData) =>
                    new App.Views.Shipping _.extend options, {
                        collection: addresses
                        @itemspot
                        wizardData
                    }
            }
            {
                id: 'billing'
                title: '2. Billing'
                icon: 'tag'
                initialize: (options) => (wizardData) =>
                    new App.Views.PaypalBilling _.extend options, {
                        collection: addresses
                        @itemspot
                        params
                        wizardData
                    }
            }
            {
                id: 'confirm'
                title: '3. Confirm'
                icon: 'user'
                initialize: (options) => (wizardData) =>
                    new App.Views.Confirm _.extend options, {
                        @itemspot
                        wizardData
                    }
            }
        ]


        super options

    getStepUrl: (stepId) ->
        "#{@itemspot.getCheckoutUrl()}/#{stepId}"

    completed: (wizardData) ->
        console.debug 'Purchase wizard has been completed.'
        console.debug wizardData
        # Commit purchase here
        App.router.navigate "#{@itemspot.getRouterUrl()}/thanks", {trigger: true}

    cleanup: ->
        console.debug "Cleaning up purchase wizard view."
        App.auth.events.off()
