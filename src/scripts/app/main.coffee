
App.events.on 'ready', ->

    console.debug 'Initializing main.'

    # Underscore mixins
    _.mixin
        # _.map for objects, keeps key/value associations
        objMap: (input, mapper, context) ->
            cb = (obj, v, k) ->
                obj[k] = mapper.call(context, v, k, input);
                obj
            _.reduce input, cb, {}, context

    # Adding support for our precompiled handlebars templates in Backbone.LayoutManager
    Backbone.LayoutManager.configure

        fetch: (name) ->
            App.templates[name]

        render: (template, context) ->
            @el = template context


    # Unbind event handlers on view close
    Backbone.View::close = ->
        console.info "Closing view #{@}"
        @beforeClose() if @beforeClose
        @remove()
        @unbind()

    # This line will initialize the app :D
    App.initialize()

    # Trigger the initial route and enable HTML5 History API support.
    Backbone.history.start
        pushState: (not App.isPhonegap) # disable push state on phonegap build, since it breaks the router.
        root: App.config.urls.root

    # All navigation that is relative should be passed through the navigate
    # method, to be processed by the router. If the link has a `data-bypass`
    # attribute, bypass the delegation completely.
    $(document).on 'vclick', 'a[href]:not([data-bypass])', (event) ->
        href =
            prop: $(this).prop 'href'
            attr: $(this).attr 'href'

        root = "#{App.location}#{App.config.urls.root}"

        if href.prop[0..root.length-1] is root
            event.preventDefault()
            Backbone.history.navigate href.attr, true
