

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
        if App.auth.isLoggedIn then @setLogoutMode() \
                               else @setLoginMode()

    clicked: =>
        App.auth.logout() if @mode is 'logout'
        return true

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

    initialize: (options) ->
        _.each (options.items or []), (item) =>
            ViewClass = item.viewClass or App.Views.MenuItem
            @insertView new ViewClass item


class App.Views.Header extends Backbone.LayoutView

    template: 'header'
    className: 'header'

    events:
        'vclick .left-action':  'backButtonClicked'
        'vclick .right-action': 'toggleMenu'
        # Close the menu when a menu item is clicked.
        'vclick .menu.active':  'closeMenu'

    initialize: ->
        console.debug 'Initializing header.'

    backButtonClicked: ->
        @closeMenu()
        window.history.back()

    toggleMenu: ->
        if @menu then @_removeMenu() else @_createMenu()
        @render()

    closeMenu: ->
        if @menu
            @_removeMenu()
            @render()

    _createMenu: ->
        @menu = new App.Views.Menu
            items: [
                {viewClass: App.Views.AuthMenuItem}
                {title: 'Home', url: '/'}
                {title: 'Profile', url: '/profile'}
            ]
        @setView '.menu', @menu

    _removeMenu: ->
        @menu.remove()
        @menu = null

    serialize: ->
        menuItems = []
        for title, href of @menuItems
            href = href() if _.isFunction href
            menuItems.push {title, href}

        {menuItems}
