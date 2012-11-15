

class App.Views.PurchaseWizard extends App.Views.Wizard

    className: 'purchase-wizard'

    keep: false

    initialize: (options) ->
        console.debug "Purchase wizard initializing."
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


