
class App.Views.Header extends Backbone.LayoutView

    template: 'header'
    className: 'header'

    events:
        'click .left-action': 'back'
        'click .right-action': 'toggleMenu'
        # Close the menu when a menu link is clicked.
        'click .menu.active': 'closeMenu'

    menuItems:
        'Login':   '/login'
        'Home':    '/'
        'Profile': '/profile'

    back: ->
        window.history.back()

    toggleMenu: ->
        (@$el.find '.menu').toggleClass 'active'

    closeMenu: ->
        (@$el.find '.menu').removeClass 'active'

    serialize: ->
        menuItems: ({title,href} for title, href of @menuItems)
