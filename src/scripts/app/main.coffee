
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

    if App.isPhonegap
        window.onerror = (error) -> console.error error

    # Adding support for our precompiled handlebars templates in Backbone.LayoutManager
    Backbone.LayoutManager.configure

        fetch: (name) ->
            # console.debug "Fetching template '#{name}'."
            template = App.templates[name]
            return template

        render: (template, context) ->
            @el = template context


    # Unbind event handlers on view close
    Backbone.View::close = ->
        console.info "Closing view #{@}"
        @beforeClose() if @beforeClose
        @remove()
        @unbind()

    # If touch events are supported, call `event.preventDefault()` on all `vclick`
    # events. The purpose of this is to prevent ghost click events.
    #
    # This little bit of magic saves us from having to write the line:
    # `event.preventDefault() if Modernizr.touch` on every single `vclick` event
    # handler.
    #
    # See: "Canceling an element's default click behavior"
    #      http://jquerymobile.com/test/docs/api/events.html
    do ->
        # This is the code that gets added to every `vclick` event handler
        wrapEventHandler = (method) -> (event) ->
            event.preventDefault() if Modernizr.touch
            method.call @, event

        # Taken from Backbone source
        getValue = (object, prop) ->
            return null if not (object and object[prop])
            return if _.isFunction object[prop] then object[prop]() else object[prop]

        # Taken from Backbone source
        delegateEventSplitter = /^(\S+)\s*(.*)$/

        # Extending `Backbone.View.delegateEvents`
        originalDelegateEvents = Backbone.View::delegateEvents
        Backbone.View::delegateEvents = (events) ->
            return if (not (events || (events = getValue(@, 'events'))))

            for key, method of events
                eventType = (key.match delegateEventSplitter)[1]
                continue unless eventType is 'vclick'

                if not _.isFunction method
                    method = @[events[key]]
                    method = wrapEventHandler method
                    @[events[key]] = method
                else
                    method = wrapEventHandler method
                    events[key] = method

            # Calling original `delegateEvents` function
            originalDelegateEvents.call @, events

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
        event.preventDefault() if Modernizr.touch
        href =
            prop: $(this).prop 'href'
            attr: $(this).attr 'href'

        root = "#{App.location}#{App.config.urls.root}"

        if href.prop[0..root.length-1] is root
            event.preventDefault()
            Backbone.history.navigate href.attr, true
