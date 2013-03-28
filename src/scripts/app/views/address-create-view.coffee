

class App.Views.AddressCreate extends App.Views.AddressModeView
    template:  'address-create'
    className: 'address-create'

    fields:
        postalCode: '#shipping-postalcode'
        firstName:  '#shipping-firstname'
        lastName:   '#shipping-lastname'
        street:     '#shipping-street'

    validateForm: (callbacks) ->
        fieldValues = @getFieldValues()
        invalidFields = (name for name, value of fieldValues when value.length is 0)

        if not _.isEmpty invalidFields
            return callbacks.error? 'Fill in all fields'

        postalCode = fieldValues.postalCode
        validPostalCode = PostalCodeUtils.validate postalCode

        if not validPostalCode
            return callbacks.error? 'Please enter a valid postal/zip code'

        callbacks.success? fieldValues

    submitForm: (cleanedFields, callbacks) ->

        if App.config.offlineMode
            address = new App.Models.Address cleanedFields
            @collection.add address
            return callbacks.success {address}

        @collection.create cleanedFields,
                success: (address) ->
                    callbacks.success {address}


# TODO: need to port this..
PostalCodeUtils = do ->

    validate: (postalCode) ->
        return false if not postalCode
        isZip = (postalCode.match /[0-9]{5}/i) isnt null
        isPostal = (postalCode.match /[a-z][0-9][a-z] ?[0-9][a-z][0-9]/i) isnt null
        isZip or isPostal

    sanitize: (postalCode) ->
        postalCode.replace ' ', ''

    getCityAndProvince: (postalCode, callbacks) ->
        sanitizedPostalCode = @sanitizePostalCode postalCode
        url = @_getCityAndProvinceLookupUrl sanitizedPostalCode, 'canada'

        $.getJSON url, (data) ->
            errorCode = parseInt data.ResultSet.Error
            errorMessage = data.ResultSet.ErrorMessage
            return callbacks.error errorCode, errorMessage, data if errorCode isnt 0

            noResultsFound = (data.ResultSet.Found == 0)
            return callbacks.noResultsFound() if noResultsFound

            result = data.ResultSet.Results[0]
            callbacks.success
                city: result.city
                province: result.state
                country: result.country

    _getCityAndProvinceLookupUrl: (postalCode, country) ->
        "http://where.yahooapis.com/geocode?q=#{postalCode},#{country}&flags=J"

