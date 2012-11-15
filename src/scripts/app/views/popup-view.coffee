
class App.Views.Popup extends Backbone.LayoutView

    template: 'popup'
    className: 'dim-overlay'

    initialize: (options) ->
        @title = options.title
        @instructions = options.instructions
        @setContentView options?.contents if options.contents

    setContentView: (@contents) ->
        @setView '.contents', @contents

    serialize: ->
        {@title, @instructions}
