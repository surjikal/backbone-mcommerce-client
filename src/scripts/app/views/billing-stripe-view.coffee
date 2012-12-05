
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
        callback null, 'debug_stripe_token'


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
        'vclick #wizard-next-step':       'wizardNextStepClicked'

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
        super options
        @key = options.key
        @tokenName = options.tokenName

    renderToken: (token) ->
        @$token = $('<input type="hidden">');
        @$token.attr 'name', @tokenName
        @$token.val token
        # append to form

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
            # @setFieldErrors invalidFields
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
                $button.attr 'disabled', false

    wizardNextStepClicked: (event) ->
        event.preventDefault()

        if not @pending
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
                            @completed {token: response}

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
        # @formatNumberField event, (digit = '') =>

        #     if (Stripe.cardType cardNumber) is 'American Express'
        #         lastDigitsRegex = /^(\d{4}|\d{4}\s\d{6})$/
        #         maxlength = 16 # 14 digits + 2 spaces
        #     else
        #         lastDigitsRegex = /(?:^|\s)(\d{4})$/
        #         maxlength = 19 # 16 digits + 3 spaces

        #     rawCardNumber = (@getFieldValue 'cardNumber') + digit
        #     cardNumber = @digitGroups ' ', /(\d{4})/g, rawCardNumber

        #     @setFieldValue 'cardNumber', cardNumber if cardNumber.length <= maxlength

        return true

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
