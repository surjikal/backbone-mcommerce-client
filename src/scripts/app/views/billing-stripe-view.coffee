
Stripe =
    setPublishableKey: ->
    validateCardNumber: (x) -> x

    validateExpiry: (month, year) ->
        month and year

    validateCVC: (cvc) -> cvc

    cardType: (cardNumber) ->
        return "MasterCard" if cardNumber.match /^(51|52|53|54|55)/
        return "Visa" if cardNumber.match /^4/
        'Unknown'

    createToken: (options, callback) ->
        callback null, 'fake_stripe_token'


class App.Views.StripeBilling extends App.Views.WizardStep

    template: 'billing-stripe'
    className: 'content billing-stripe'

    fields:
        'cardNumber': '#billing-card-number'
        'expiry':     '#billing-expiry'
        'cvc':        '#billing-cvc'

    events:
        'keydown input':                 'performValidation'
        'keyup    #billing-card-number': 'changeCardType'
        'keydown  #billing-card-number': 'cardNumberDigitEntered'
        'keydown  #billing-expiry':      'formatExpiry'
        'keypress #billing-cvc':         'restrictNumber'
        'click #wizard-next-step':      'wizardNextStepClicked'
        'click #scan-card-button':       'scanCardButtonClicked'

    cardTypes:
        'Visa':             'visa'
        'American Express': 'amex'
        'MasterCard':       'mastercard'
        'Discover':         'discover'
        'Unknown':          'unknown'

    normalizeErrorCodes:
        'card_declined':        'cardDeclined'
        'invalid_number':       'invalidCardNumber'
        'incorrect_number':     'incorrectCardNumber'
        'invalid_expiry_month': 'invalidExpiryMonth'
        'invalid_expiry_year':  'invalidExpiryYear'
        'expired_card':         'expiredCard'
        'invalid_cvc':          'invalidCvc'

    errorCodeToField:
        'cardDeclined':        'cardNumber'
        'invalidCardNumber':   'cardNumber'
        'incorrectCardNumber': 'cardNumber'
        'expiredCard':         'cardNumber'
        'invalidExpiryMonth':  'expiry'
        'invalidExpiryYear':   'expiry'
        'invalidCvc':          'cvc'

    initialize: (options) ->
        super
        {key, itemspot} = options
        @setKey key
        @setView '.order-table', new App.Views.OrderTable {itemspot}

    setKey: (key) ->
        @key = key
        Stripe.setPublishableKey @key

    getFieldValues: ->
        fieldValues = super()
        [expiryMonth, expiryYear] = fieldValues.expiry?.split ' / '
        expiryMonth or= ''
        expiryYear or= ''
        _.extend fieldValues, {expiryMonth, expiryYear}

    validateForm: (callbacks) ->
        @clearFieldErrors()
        fieldValues = @getFieldValues()

        invalidFields = (name for name, value of fieldValues when value?.length is 0)

        if not _.isEmpty invalidFields or not (fieldValues.cvc.length in [3,4])
            return callbacks.error? 'Fill in all fields'

        if not Stripe.validateCardNumber fieldValues.cardNumber
            return callbacks.error? 'Invalid card number'

        if not Stripe.validateExpiry fieldValues.expiryMonth, fieldValues.expiryYear
            return callbacks.error? 'Invalid card expiry'

        if not Stripe.validateCVC fieldValues.cvc
            return callbacks.error? 'Invalid CVC'

        callbacks.success fieldValues

    performValidation: (event) -> _.defer =>
        $button = $('#wizard-next-step')
        @validateForm
            error: (message) ->
                $button.text message
                $button.attr 'disabled', true
            success: (cleanedFields) ->
                $button.text 'Continue'
                $button.removeAttr 'disabled'

    beforeNextStep: (done) ->
        return if @pending

        @enablePending()
        @validateForm
            error: (errorMessage) ->
                console.error errorMessage
                @disablePending()
            success: (cleanedFields) =>
                @disablePending()
                @createToken cleanedFields,
                    error: (error) ->
                        console.error error
                    success: (response) =>
                        console.debug "Stripe#createToken success:\n", response
                        done {token: response}

    createToken: (fieldValues, callbacks) ->

        complete = (status, response) ->
            return callbacks.error? response.error if response.error
            callbacks.success? response

        fieldValues = @getFieldValues()

        Stripe.createToken(
            number:    fieldValues.cardNumber
            exp_month: fieldValues.expiryMonth
            exp_year:  fieldValues.expiryYear
            cvc:       fieldValues.cvc
        , complete)

    cardNumberDigitEntered: (event) ->

        @formatNumberField event, (digit = '') =>

            rawCardNumber = (@getFieldValue 'cardNumber') + digit
            cardNumber = @digitGroups ' ', /(\d{4})/g, rawCardNumber

            if (Stripe.cardType cardNumber) is 'American Express'
                lastDigitsRegex = /^(\d{4}|\d{4}\s\d{6})$/
                maxlength = 16 # 14 digits + 2 spaces
            else
                lastDigitsRegex = /(?:^|\s)(\d{4})$/
                maxlength = 19 # 16 digits + 3 spaces

            @setFieldValue 'cardNumber', cardNumber if cardNumber.length <= maxlength

    formatExpiry: (event) ->
        @formatNumberField event, (digit = '') =>
            expiry = (@getFieldValue 'expiry') + digit
            expiry = @digitGroups ' / ', /(\d{2})/g, expiry
            @setFieldValue 'expiry', expiry if expiry.length <= 7 # 4 digits + 2 spaces + 1 slash

            # expiryMonth = expiry.match /(?:^|\s|\/)(\d{2})$/
            # maxlength = 7 # 4 digits + 2 spaces + 1 front slash
            #(@setFieldValue 'expiry', "#{expiry} / ") if expiryMonth and expiry.length isnt maxlength

    digitGroups: (join, regex, cardNumber) ->
        cardNumber  = cardNumber.replace /[^\d]+/g, ''
        digitGroups = cardNumber.split regex
        digitGroups = _.reject digitGroups, (digitGroup) -> not digitGroup
        digitGroups.join join

    formatNumberField: (event, formatter) ->
        # Allow shift, ctrl, etc.
        return true if event.metaKey

        # Allow backspace. Deferring since we want to format after the
        # backspace has occured.
        if event.which is 8
            _.defer formatter
            return true

        # Allow if it's a tab or left/right arrow
        return true if event.which in [9,37,39]

        # Disallow any non-digits
        digit = String.fromCharCode event.which
        return false if not (/^\d+$/.test digit)

        # Sending the digit because we want to do the formatting on the next
        # state of the input. Otherwise, we will do it on its state before the
        # this event.
        formatter digit
        return false

    restrictNumber: (event) ->
        return true if event.shiftKey or event.metaKey
        return true if event.which is 0
        char = String.fromCharCode event.which
        return not /[A-Za-z]/.test char

    changeCardType: (event) ->
        type = Stripe.cardType @getFieldValue 'cardNumber'
        $cardNumber = @getField 'cardNumber'

        if not $cardNumber.hasClass type

            for name, map of @cardTypes
                $cardNumber.removeClass map

            $cardNumber.addClass @cardTypes[type]

    handleError = (err) ->
        console.error "Stripe error: #{err.message}"
        normalizedErrorCode = normalizeErrorCodes[err.code]
        return if not normalizedErrorCode

        fieldName = errorCodeToField[normalizedErrorCode]
        @setFieldError fieldName

    expiryVal: ->
        trim = (s) -> s.replace /^\s+|\s+$/g, ''
        month = trim @getFieldValue 'expiryMonth'
        year = trim @getFieldValue 'expiryYear'

        if year.length is 2
            prefix = (new Date).getFullYear()
            prefix = prefix.toString()[0..1]
            year = prefix + year

        {month, year}

    scanCardButtonClicked: ->
        controller = new App.Controllers.CardIO App.config.cardio.key

        scanOptions =
            disableManualEntryButtons: true
            collectExpiry: true
            collectCVV: true

        controller.scan scanOptions, success: @onCreditCardScanSuccess

    onCreditCardScanSuccess: ({cardNumber, expiryMonth, expiryYear, cvv}) =>

        formatExpiry = (expiryMonth, expiryYear) ->
            expiryYear = String(expiryYear)[2..]
            expiry = "#{expiryMonth} / #{expiryYear}"

        @setFieldValue 'cardNumber', cardNumber
        @setFieldValue 'expiry', formatExpiry expiryMonth, expiryYear
        @setFieldValue 'cvc', cvv
        @performValidation()


class App.Controllers.CardIO

    constructor: (@key) ->
        console.debug "CardIO using key: #{@key}"

    scan: (options, callbacks = {}) ->
        {success, cancelled} = (if callbacks then callbacks else options)
        dummy = (->)
        @_callPlugin @key, options, (success or dummy), (cancelled or dummy)

    _callPlugin: (key, options, onSuccess, onError) ->
        window.plugins.card_io.scan key, options, onSuccess, onError
