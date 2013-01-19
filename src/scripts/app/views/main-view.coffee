
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

        # HACKCKKCKCKCK
        if page.className is 'boutique-select-view'
            @$('#page').addClass 'no-border'
        else
            @$('#page').removeClass 'no-border'

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

