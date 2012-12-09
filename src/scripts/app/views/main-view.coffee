
class App.Views.Main extends Backbone.LayoutView

    el: 'body'

    showLoginPopup: =>
        @showPopup new App.Views.LoginOrNewUserPopup()

    showPopup: (@popup) ->
        @setView '#popup', @popup
        @popup.render()

    removePopup: ->
        @popup?.remove()
        @popup = null

    setPageView: (page, removeHeader = false) ->
        if removeHeader then @removeHeader() else @attachHeader()
        @setView '#page', page
        page.render()

    attachHeader: ->
        return if @header
        @header = new App.Views.Header()
        @setView '#header', @header
        @header.render()

    removeHeader: ->
        @header?.remove()
        @header = null

