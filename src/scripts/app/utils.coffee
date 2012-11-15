
App.utils =

    postJSON: (options) ->
        options.type = 'post'
        @ajaxJSON options

    getJSON: (options) ->
        options.type = 'get'
        @ajaxJSON options

    ajaxJSON: (options) ->

        if not options.url
            throw "Missing url option."

        if not options.type
            throw "Missing type options."

        $.ajax
            url: options.url
            type: options.type
            dataType: 'json'
            contentType: 'application/json'
            data: (JSON.stringify (options.data or {})) if options.data

            error: (jqXHR, textStatus, errorThrown) ->
                response = JSON.parse jqXHR.responseText
                callback = options.callbacks[response?.reason or 'error']
                callback?(jqXHR, textStatus, errorThrown)

            success: (data) ->
                options.callbacks.success data

