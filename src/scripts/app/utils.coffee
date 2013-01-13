
App.utils =

    json:

        post: (options) ->
            options.type = 'post'
            @ajax options

        get: (options) ->
            options.type = 'get'
            @ajax options

        ajax: ({url, type, data, auth, callbacks}) ->
            throw "Missing url option."  if not url
            throw "Missing type option." if not type

            if not callbacks
                console.warn "No callbacks specified."
                callbacks = {}

            $.ajax {
                url
                type
                dataType: 'json'
                contentType: 'application/json'
                data: (JSON.stringify data) if data
                headers: Authorization: auth if auth

                error: (jqXHR, textStatus, errorThrown) =>
                    response = @_parseReponseText jqXHR.responseText
                    response = switch jqXHR.status
                        when 500
                            # @_handleInternalServerError jqXHR
                            response or {reason:'serverError'}
                        when 401
                            @_handleUnauthorizedError jqXHR
                            response or {reason:'unauthorized'}
                        else
                            response

                    reason = response?.reason
                    callback = callbacks[response?.reason]

                    if not callback and reason
                        console.debug response
                        console.debug "Error reason '#{reason}' unhandled. Reverting to 'error' callback (if any)."
                        callback = callbacks.error

                    return callback?(jqXHR, textStatus, errorThrown)

                success: (data) ->
                    callbacks.success data
            }

        _parseReponseText: (responseText) ->
            return try response = JSON.parse responseText

        _handleInternalServerError: (jqXHR) ->
            responseText = jqXHR.responseText
            error = @_parseReponseText responseText

            errorMessage  = "Internal server error:\n\n"

            if error
                errorMessage += "#{error.errorMessage}\n\n" if error.errorMessage
                errorMessage += "#{error.traceback}"
            else
                errorMessage += responseText

            console.error errorMessage

        _handleUnauthorizedError: (jqXHR) ->
            console.error "Unauthorized to make this ajax call."


    # Generate a pseudo-GUID by concatenating random hexadecimal.
    guid: do ->
        S4 = -> (((1+Math.random())*0x10000)|0).toString(16).substring(1)
        -> "#{S4()}#{S4()}-#{S4()}-#{S4()}-#{S4()}#{S4()}#{S4()}"


    getRandomNumber: (min, max) ->
        Math.random() * (max - min + 1) + min


    getRandomInteger: (min, max) ->
        Math.floor (@getRandomNumber min, max)
