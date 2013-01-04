
class App.Views.PaypalBilling extends App.Views.WizardStep

    template: 'billing-paypal'
    className: 'content billing-paypal'

    dependencies: [
        'address'
    ]

    initialize: (options) ->
        super
        {@itemspot, user, params} = options
        {@address} = options.wizardData

        @controller = if App.config.paypal.useMockController then new MockPaypalBillingController() \
                                                             else new PaypalBillingController()

        if params.callback
            return _.defer =>
                @handleCallback params

        @setView '.order-table', new App.Views.OrderTable {@itemspot}

        # App.router.navigate "#{@itemspot.getCheckoutUrl()}", {trigger: false, replace: true}

    beforeNextStep: ->
        # email = @user.get 'email'
        @enablePending -1

        @controller.getToken @address, @itemspot,
            success: (response) =>
                @handleToken response.token
            error: =>
                @disablePending()
                alert 'Something went wrong. Please try again!'

    handleToken: (token) ->
        console.debug "Received token: #{token}"
        @controller.showCheckoutPage token, @collection, @address, @itemspot

    handleCallback: (params) ->
        switch params.callback
            when "success"
                throw new Error "Did not receive PayerID from PayPal checkout." if not params.PayerID
                @handleCheckoutSuccess @address, params.PayerID
            when "cancelled"
                @handleCheckoutCancelled @address
            else
                throw new Error "Callback is empty."

    handleCheckoutSuccess: (address, payerId) ->
        console.debug "PayPal payment authorization was successful."
        @completed {address, payerId}

    handleCheckoutCancelled: (@address) =>
        console.debug "PayPal payment authorization was cancelled."


class PaypalBillingController

    getToken: (address, itemspot, callbacks) ->
        [successUrl, cancelUrl] = @_getCallbackUrls itemspot
        App.api.purchase.getToken address, itemspot, successUrl, cancelUrl, callbacks

    showCheckoutPage: (token, addresses, address, itemspot) ->

        phonegap = ->
            console.debug "NOT IMPLEMENTED"

        website = =>
            console.debug "Opening paypal page..."
            @_openPaypalCheckoutPage token

        if App.isPhonegap then phonegap() else website()

    _openPaypalCheckoutPage: (token) ->
        paypalUrl = @_getPaypalUrl token
        window.location.href = paypalUrl

    _getPaypalUrl: (token) ->
        "#{App.config.urls.paypal.base}/cgi-bin/webscr?cmd=_express-checkout&token=#{token}"

    _getCallbackUrls: (itemspot) ->
        urlPrefix = @_getCallbackUrlPrefix()
        ["#{urlPrefix}success", "#{urlPrefix}cancel"]

    _getCallbackUrlPrefix: ->
        separator = if window.location.search then '&' else '?'
        "#{window.location.href}#{separator}callback="


class MockPaypalBillingController extends PaypalBillingController

    FAKE_TOKEN: 'omgwtfbbq'
    FAKE_PAYER_ID: 'lolsecret'

    getToken: (address, itemspot, callbacks) ->
        [successUrl, cancelUrl] = @_getCallbackUrls itemspot
        callbacks.success {token: successUrl}

    _openPaypalCheckoutPage: (successUrl) ->
        alert "I'm pretending to be PayPal! Shall we continue?"
        url = "#{successUrl}&PayerID=#{@FAKE_PAYER_ID}"
        window.location.href = url
