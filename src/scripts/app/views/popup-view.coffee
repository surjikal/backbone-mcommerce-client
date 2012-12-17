
class App.Views.Popup extends Backbone.LayoutView

    template: 'popup'
    className: 'dim-overlay'

    events:
        'click .close': 'closeButtonClicked'

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
        App.views.main.removePopup()

    closeButtonClicked: ->
        @close()
        @callbacks.closed?()

    setTitle: (@title) ->

    setInstructions: (@instructions) ->

    setContents: (@contents) ->
        @setView '.contents', @contents

    serialize: ->
        {@title, @instructions}
