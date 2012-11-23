

class App.Views.PurchaseWizard extends App.Views.Wizard

    className: 'purchase-wizard'

    initialize: (options) ->
        console.debug "Initializing purchase wizard."

        {user, itemspot} = options
        addresses = (user.get 'account').get 'addresses'

        App.auth.events.on 'logout', ->
            App.router.navigate itemspot.getRouterUrl(), {trigger: true}

        super
            steps: [
                {
                    title: '1. Shipping'
                    icon: 'house'
                    view: (options) ->
                        new App.Views.Shipping _.extend options,
                            collection: addresses
                }
                {
                    title: '2. Billing'
                    icon: 'tag'
                    view: (options) ->
                        new App.Views.StripeBilling options
                }
                {
                    title: '3. Confirm'
                    icon: 'user'
                    view: (options) ->
                        new App.Views.Confirm options
                }
            ]

    cleanup: ->
        console.debug "Cleaning up purchase wizard view."
        App.auth.events.off null, null, @


