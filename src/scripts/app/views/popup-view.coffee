
class App.Views.Popup extends Backbone.LayoutView

    template: 'popup'
    className: 'dim-overlay'

    events:
        'vclick .close': 'close'

    initialize: (options) ->
        @title        = options.title
        @callbacks    = options.callbacks
        @instructions = options.instructions

        @setContents options.contents if options.contents

    close: ->
        App.views.main.removePopup()
        @callbacks.closed?()

    setTitle: (@title) ->

    setInstructions: (@instructions) ->

    setContents: (@contents) ->
        @setView '.contents', @contents

    serialize: ->
        {@title, @instructions}
