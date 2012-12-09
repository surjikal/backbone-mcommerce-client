
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

            if not options.callbacks
                console.warn "No callbacks specified."
                options.callbacks = {}

            $.ajax
                url: options.url
                type: options.type
                dataType: 'json'
                contentType: 'application/json'
                data: (JSON.stringify options.data) if options.data

                error: (jqXHR, textStatus, errorThrown) =>
                    response = @_parseReponseText jqXHR.responseText
                    response = switch jqXHR.status
                        when 500
                            @_handleInternalServerError jqXHR
                            response or {reason:'serverError'}
                        when 401
                            @_handleUnauthorizedError jqXHR
                            response or {reason:'unauthorized'}
                        else
                            response

                    reason = response?.reason
                    callback = options.callbacks[response?.reason]

                    if not callback and reason
                        console.debug response
                        console.debug "Error reason '#{reason}' unhandled. Reverting to 'error' callback (if any)."
                        callback = options.callbacks.error

                    return callback?(jqXHR, textStatus, errorThrown)

                success: (data) ->
                    options.callbacks.success data

        _parseReponseText: (responseText) ->
            return try response = JSON.parse responseText

        _handleInternalServerError: (jqXHR) ->
            responseText = jqXHR.responseText
            error = @_parseReponseText responseText

            errorMessage  = "Internal server error:\n\n"
            errorMessage += if response then "#{error.errorMessage}\n\n#{error.traceback}" \
                                        else responseText

            console.error errorMessage

        _handleUnauthorizedError: (jqXHR) ->
            console.error "Unauthorized to make this ajax call."


    # Generate a pseudo-GUID by concatenating random hexadecimal.
    guid: do ->
        s4 = -> (((1+Math.random())*0x10000)|0).toString(16).substring(1)
        -> "#{S4()}#{S4()}-#{S4()}-#{S4()}-#{S4()}#{S4()}#{S4()}"
