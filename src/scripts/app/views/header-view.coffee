

class App.Views.MenuItem extends Backbone.LayoutView
    template: 'menu-list-item'
    tagName: 'li'

    initialize: (options) ->
        {@title, @url} = options

    serialize: ->
        {@title, @url}


class App.Views.AuthMenuItem extends App.Views.MenuItem

    events:
        'vclick': 'clicked'

    initialize: ->
        console.debug 'Initializing auth menu item.'
        if App.auth.isLoggedIn then @setLogoutMode() \
                               else @setLoginMode()
        @initEventListeners()

    initEventListeners: ->
        App.auth.events.on 'login', @onLogin, @
        App.auth.events.on 'logout', @onLogout, @

    clicked: =>
        App.auth.logout() if @mode is 'logout'

    onLogin: =>
        @setLogoutMode()
        @render()

    onLogout: =>
        @setLoginMode()
        @render()

    setLoginMode: ->
        @mode  = 'login'
        @title = 'Login'
        @url   = '/login'

    setLogoutMode: ->
        @mode  = 'logout'
        @title = 'Logout'
        @url   = null


class App.Views.Menu extends Backbone.LayoutView
    tagName: 'ul'
    className: 'menu'

    initialize: (options) ->
        @initializeMenuItems options.items

    initializeMenuItems: (items = []) ->
        _.each items, (item) =>
            ViewClass = item.viewClass or App.Views.MenuItem
            @insertView new ViewClass item

    toggleVisibility: ->
        @$el.toggleClass 'active'

    close: ->
        @$el.removeClass 'active'


class App.Views.Header extends Backbone.LayoutView

    template: 'header'
    className: 'header'

    events:
        'vclick .left-action':  'leftActionClicked'
        'vclick .right-action': 'rightActionClicked'
        # Close the menu when a menu item is clicked.
        'vclick .menu.active':  'closeMenu'

    initialize: ->
        console.debug 'Initializing header.'
        @setView '.menu-view', (@menu = @createMenu())

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
        @menu.close()
        window.history.back()
