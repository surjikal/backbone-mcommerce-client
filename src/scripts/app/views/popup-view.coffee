
class App.Views.Popup extends Backbone.LayoutView

    template: 'popup'
    className: 'popup-view'

    events:
        'click .close, .dim-overlay': 'close'

    initialize: (options) ->
        @title        = @title        or options.title
        @instructions = @instructions or options.instructions
        @callbacks    = options.callbacks
        @initializeContents options

    initializeContents: (options) ->
        contents = @contents or options.contents
        contents = contents? options
        @setContents contents if contents

    close: ->
        @_close()
        @callbacks.closed?()

    setTitle: (@title) ->

    setInstructions: (@instructions) ->

    setContents: (@contents) ->
        @setView '.contents', @contents

    serialize: ->
        {@title, @instructions}

    _close: ->
        App.views.main.removePopup()