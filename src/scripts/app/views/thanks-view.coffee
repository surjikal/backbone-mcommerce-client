
class App.Views.Thanks extends Backbone.LayoutView
    template: 'thanks'
    className: 'content thanks'

    initialize: (options) ->
        @boutiqueCode = options.boutiqueCode
        @index = options.index

    serialize: ->
        item:
            name: 'BaconSauce'