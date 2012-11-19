
class App.Views.Popup extends Backbone.LayoutView

    template: 'popup'
    className: 'dim-overlay'

    initialize: (options) ->
        @title        = options?.title
        @instructions = options?.instructions
        @setContents options.contents if options?.contents

    setTitle: (@title) ->

    setInstructions: (@instructions) ->

    setContents: (@contents) ->
        @setView '.contents', @contents

    serialize: ->
        {@title, @instructions}
