

class App.Views.PurchaseWizard extends App.Views.Wizard

    className: 'purchase-wizard'

    initialize: (options) ->
        console.debug "Initializing purchase wizard."

        App.auth.events.on 'logout', ->
            App.router.navigate "/boutiques/#{options.boutiqueCode}", {trigger: true}

        super _.extend options,
            steps: [
                # {
                #     title: 'PayPal'
                #     icon: 'tag'
                #     view: new App.Views.PaypalBilling options
                # }
                {
                    title: '1. Shipping'
                    icon: 'house'
                    viewClass: App.Views.Shipping
                }
                {
                    title: '2. Billing'
                    icon: 'tag'
                    viewClass: App.Views.StripeBilling
                }
                {
                    title: '3. Confirm'
                    icon: 'user'
                    viewClass: App.Views.Confirm
                }
            ]


