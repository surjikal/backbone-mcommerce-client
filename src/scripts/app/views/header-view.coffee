

class App.Views.MenuItem extends Backbone.LayoutView
    template: 'menu-list-item'
    tagName: 'li'

    initialize: (options) ->
        {@title, @url} = options

    serialize: ->
        {@title, @url}


class App.Views.AuthMenuItem extends App.Views.MenuItem

    initialize: ->
        console.debug 'Initializing auth menu item.'
        if App.auth.isLoggedIn then @setLogoutMode() \
                               else @setLoginMode()
        App.auth.events.on 'login', @onLogin
        App.auth.events.on 'logout', @onLogout

    onLogin: =>
        @setLogoutMode()
        @render()

    onLogout: =>
        @setLoginMode()
        @render()

    setLoginMode: ->
        @title = 'Login'
        @url   = '/login'

    setLogoutMode: ->
        @title = 'Logout'
        @url   = '/logout'


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
        'click .left-action':  'backButtonClicked'
        'click .right-action': 'toggleMenu'
        # Close the menu when a menu item is clicked.
        'click .menu.active':  'closeMenu'

    initialize: ->
        console.debug 'Initializing header.'
        @setView '.menu', @createMenu()

    createMenu: ->
        new App.Views.Menu
            items: [
                {viewClass: App.Views.AuthMenuItem}
                {title: 'Home', url: '/'}
                {title: 'Profile', url: '/profile'}
            ]

    backButtonClicked: ->
        @closeMenu()
        window.history.back()

    toggleMenu: ->
        (@$el.find '.menu').toggleClass 'active'

    closeMenu: ->
        (@$el.find '.menu').removeClass 'active'

    serialize: ->
        menuItems = []
        for title, href of @menuItems
            href = href() if _.isFunction href
            menuItems.push {title, href}

        {menuItems}
