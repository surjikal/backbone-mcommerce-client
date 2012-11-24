
$ ->

    _.mixin
        # _.objMap
        # _.map for objects, keeps key/value associations
        objMap: (input, mapper, context) ->
            cb = (obj, v, k) ->
                obj[k] = mapper.call(context, v, k, input);
                obj
            _.reduce input, cb, {}, context

    # LayoutManager template hooks for precompiled handlebars templates.
    Backbone.LayoutManager.configure

        fetch: (name) ->
            console.debug "Fetching template '#{name}'."
            template = App.Templates[name]
            return template

        render: (template, context) ->
            @el = template context

    # Unbind event handlers on view close
    Backbone.View.prototype.close = ->
        console.info "Closing view #{@}"
        @beforeClose() if @beforeClose
        @remove()
        @unbind()

    # Setup ajax status code handlers
    $.ajaxSetup
        statusCode:
            500: (jqXHR) ->
                errorMessage = "INTERNAL SERVER ERROR:\n\n"
                try
                    error = JSON.parse jqXHR.responseText
                    errorMessage += "#{error.errorMessage}\n\n#{error.traceback}"
                catch e
                    console.debug "Server error is not a JSON object."
                    errorMessage += jqXHR.responseText
                console.error errorMessage

            # 401: ->
            #     App.router.navigate '/login', {trigger:true}

            # 403: ->
            #     App.router.navigate '/denied', {trigger:true}

    # Configuring defaults for the jquery.cookie plugin
    _.extend $.cookie.defaults, App.config.cookies

    # This line will initialize the app :D
    App.initialize()

    # Trigger the initial route and enable HTML5 History API support.
    Backbone.history.start
        pushState: true
        root: App.config.urls.root

    # All navigation that is relative should be passed through the navigate
    # method, to be processed by the router. If the link has a `data-bypass`
    # attribute, bypass the delegation completely.
    $(document).on 'vclick', 'a[href]:not([data-bypass])', (event) ->
        href =
            prop: $(this).prop 'href'
            attr: $(this).attr 'href'

        root = "#{location.protocol}//#{location.host}#{App.config.urls.root}"

        if href.prop[0..root.length-1] is root
            event.preventDefault()
            Backbone.history.navigate href.attr, true
