
class App.Views.PaypalBilling extends App.Views.WizardStep

    template: 'billing-paypal'
    className: 'content billing-paypal'

    events:
        'click button': 'buttonClicked'

    initialize: (options) ->
        {@user, @itemspot} = options

    buttonClicked: ->
        {address} = @data
        email = @user.get 'email'
        App.api.purchase.getToken {email, address, @itemspot},
            success: (token) ->
                console.debug arguments
            error: ->
                console.debug arguments

