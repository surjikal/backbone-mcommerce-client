
App.utils =

    json:

        post: (options) ->
            options.type = 'post'
            @ajax options

        get: (options) ->
            options.type = 'get'
            @ajax options

        ajax: (options) ->

            if not options.url
                throw "Missing url option."

            if not options.type
                throw "Missing type options."

            $.ajax
                url: options.url
                type: options.type
                dataType: 'json'
                contentType: 'application/json'
                data: (JSON.stringify options.data) if options.data

                error: (jqXHR, textStatus, errorThrown) ->
                    response = JSON.parse jqXHR.responseText
                    callback = options.callbacks[response?.reason or 'error']
                    callback?(jqXHR, textStatus, errorThrown)

                success: (data) ->
                    options.callbacks.success data

    # Generate a pseudo-GUID by concatenating random hexadecimal.
    guid: do ->
        s4 = -> (((1+Math.random())*0x10000)|0).toString(16).substring(1)
        -> "#{S4()}#{S4()}-#{S4()}-#{S4()}-#{S4()}#{S4()}#{S4()}"
