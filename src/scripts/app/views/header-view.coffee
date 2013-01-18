

class App.Views.MenuItem extends Backbone.LayoutView
    template: 'menu-list-item'
    tagName: 'li'
    className: 'menu-item'

    initialize: (options) ->
        {@title, @url} = options

    serialize: ->
        {@title, @url}


class App.Views.AuthMenuItem extends App.Views.MenuItem

    events:
        'click': 'clicked'

    initialize: ->
        console.debug 'Initializing auth menu item.'
        if App.auth.isLoggedIn then @setLogoutMode() \
                               else @setLoginMode()
        @initEventListeners()

    initEventListeners: ->
        App.auth.events.on 'login', @onLogin, @
        App.auth.events.on 'logout', @onLogout, @

    clicked: =>
        if @mode is 'logout' then @logoutClicked() \
                             else @loginClicked()

    loginClicked: =>
        popup = new App.Views.LoginPopup
            model: App.auth.user
            callbacks: success: =>
                popup.close()
        App.views.main.showPopup popup

    logoutClicked: =>
        App.auth.logout()

    onLogin: =>
        @setLogoutMode()
        @render()

    onLogout: =>
        @setLoginMode()
        @render()

    setLoginMode: ->
        @mode  = 'login'
        @title = 'Login'
        @url   = null

    setLogoutMode: ->
        @mode  = 'logout'
        @title = 'Logout'
        @url   = null


class App.Views.Menu extends Backbone.LayoutView
    tagName: 'ul'
    className: 'menu-view'

    events:
        'click': 'close'

    initialize: (options) ->
        @initializeMenuItems options.items

        # Close the menu whenever the page is changed.
        App.router.on 'all', => _.defer =>
            # For some reason, using `@close()` doesn't work.
            @$el.removeClass 'active'

    # A view item object can contain either:
    # - {title, url}: Creates a `App.Views.MenuItem` with the specified url and title    **OR**
    # - {viewClass}:  Use custom view that extends `App.Views.MenuItem`
    initializeMenuItems: (items = []) ->
        _.each items, (item) =>
            ViewClass = item.viewClass or App.Views.MenuItem
            @insertView new ViewClass item

    toggleVisibility: =>
        @$el.toggleClass 'active'

    close: =>
        @$el.removeClass 'active'


class App.Views.Header extends Backbone.LayoutView

    template: 'header'
    className: 'header-view'

    events:
        'click .left-action':  'leftActionClicked'
        'click .right-action': 'rightActionClicked'

    initialize: ->
        console.debug 'Initializing header.'
        @setView '.menu', (@menu = @createMenu())

    createMenu: ->
        new App.Views.Menu
            items: [
                {viewClass: App.Views.AuthMenuItem}
                {title: 'Home',    url: '/'}
                {title: 'Profile', url: '/profile'}
            ]

    rightActionClicked: =>
        @menu.toggleVisibility()

    leftActionClicked: =>
        window.history.back()
