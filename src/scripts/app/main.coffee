
App.events.on 'ready', ->

    console.debug 'Initializing main.'

    if App.isPhonegap

        # Global error handler to help with phonegap debugging
        window.onerror = (error) -> console.error error

    # Underscore mixins
    _.mixin
        # _.map for objects, keeps key/value associations
        objMap: (input, mapper, context) ->
            cb = (obj, v, k) ->
                obj[k] = mapper.call(context, v, k, input);
                obj
            _.reduce input, cb, {}, context


    Backbone.LayoutManager.configure

        # Adding support for our precompiled handlebars templates in `Backbone.LayoutManager`.
        fetch: (name) ->
            App.templates[name]

        render: (template, context) ->
            @el = template (_.extend {}, context,
                # These will be available in all templates.
                isPhonegap: App.isPhonegap
            )

        # Delegating to `underscore.deferred`
        # This plugin is needed because unlike jQuery, Zepto doesn't have these features.
        deferred: _.Deferred
        when:     _.when

        # Impletementation mostly taken from jQuery.
        # It assumes the browser supports the `contain` node method.
        contains: (a, b) ->
            adown = if a.nodeType is 9 then a.documentElement else bup = b and b.parentNode
            a is bup or !!(bup and bup.nodeType is 1 and adown.contains && adown.contains bup)


    # Unbind event handlers on view close
    Backbone.View::close = ->
        console.info "Closing view #{@}"
        @beforeClose() if @beforeClose
        @remove()
        @unbind()

    # Enable FastClick for fast buttons and input fields on touch-enabled browsers.
    new FastClick document.body

    # Initializing handlebars helpers
    (Handlebars.registerHelper name, fn) for name, fn of HandlebarsHelpers

    # This line will initialize the app :D
    App.initialize()

    # Trigger the initial route and enable HTML5 History API support.
    Backbone.history.start
        pushState: (not App.isPhonegap) # disable push state on phonegap build, since it breaks the router.
        root: App.config.urls.root

    # All navigation that is relative should be passed through the navigate
    # method, to be processed by the router. If the link has a `data-bypass`
    # attribute, bypass the delegation completely.
    $(document).on 'click', 'a[href]:not([data-bypass])', (event) ->
        href =
            prop: $(this).prop 'href'
            attr: $(this).attr 'href'

        root = "#{App.location}#{App.config.urls.root}"

        if href.prop[0..root.length-1] is root
            event.preventDefault()
            Backbone.history.navigate href.attr, true


HandlebarsHelpers =

    formatPrice: (price) ->
        price = parseFloat price
        decimalPlaces = if (Math.round price) == price then 0 else 2
        (new Number price).toFixed decimalPlaces
