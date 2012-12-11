

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
        'vclick': 'clicked'

    initialize: ->
        console.debug 'Initializing auth menu item.'
        if App.auth.isLoggedIn then @setLogoutMode() \
                               else @setLoginMode()

        App.auth.events.on 'login', @onLogin
        App.auth.events.on 'logout', @onLogout

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
    className: 'menu-view'

    events:
        'vclick': 'close'

    initialize: (options) ->
        _.each (options.items or []), (item) =>
            ViewClass = item.viewClass or App.Views.MenuItem
            @insertView new ViewClass item

    toggle: ->
        @$el.toggleClass 'active'

    close: ->
        @$el.removeClass 'active'


class App.Views.Header extends Backbone.LayoutView

    template: 'header'
    className: 'header-view'

    events:
        'vclick .left-action':  'goBack'
        'vclick .right-action': 'toggleMenu'

    initialize: ->
        console.debug 'Initializing header.'
        @menu = @createMenu()
        @setView '.menu', @menu

    createMenu: ->
        new App.Views.Menu
            items: [
                {viewClass: App.Views.AuthMenuItem}
                {title: 'Home', url: '/'}
                {title: 'Profile', url: '/profile'}
            ]

    goBack: ->
        @menu.close()
        window.history.back()

    toggleMenu: ->
        @menu.toggle()

    closeMenu: ->
        @menu.close()

    serialize: ->
        menuItems = []
        for title, href of @menuItems
            href = href() if _.isFunction href
            menuItems.push {title, href}

        {menuItems}
