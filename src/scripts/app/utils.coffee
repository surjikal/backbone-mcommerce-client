
App.utils =

    json:

        post: (options) ->
            options.type = 'post'
            @ajax options

        get: (options) ->
            options.type = 'get'
            @ajax options

        ajax: (options) ->
            throw "Missing url option."  if not options.url
            throw "Missing type option." if not options.type

            $.ajax
                url: options.url
                type: options.type
                dataType: 'json'
                contentType: 'application/json'
                data: (JSON.stringify options.data) if options.data

                error: (jqXHR, textStatus, errorThrown) =>

                    if jqXHR.status is 500
                        # trigger an event?
                        return @_handleInternalServerError jqXHR

                    response = @_parseReponseText jqXHR.responseText
                    callback = options.callbacks[response?.reason or 'error']
                    return callback?(jqXHR, textStatus, errorThrown)

                success: (data) ->
                    options.callbacks.success data

        _parseReponseText: (responseText) ->
            response = null
            try response = JSON.parse responseText
            return response

        _handleInternalServerError: (jqXHR) ->
            responseText = jqXHR.responseText
            error = @_parseReponseText responseText

            errorMessage  = "Internal server error:\n\n"
            errorMessage += if response then "#{error.errorMessage}\n\n#{error.traceback}" \
                                        else responseText

            console.error errorMessage


    # Generate a pseudo-GUID by concatenating random hexadecimal.
    guid: do ->
        s4 = -> (((1+Math.random())*0x10000)|0).toString(16).substring(1)
        -> "#{S4()}#{S4()}-#{S4()}-#{S4()}-#{S4()}#{S4()}#{S4()}"
