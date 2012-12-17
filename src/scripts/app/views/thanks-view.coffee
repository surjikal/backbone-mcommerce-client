
class App.Views.Thanks extends Backbone.LayoutView

    template: 'thanks'
    className: 'content thanks'

    events:
        'click #back-to-boutique': 'backToBoutiqueButtonClicked'

    initialize: (options) ->
        {@itemspot} = options

    backToBoutiqueButtonClicked: ->
        boutique = @itemspot.get 'boutique'
        App.router.navigate boutique.getRouterUrl(), {trigger: true}

    serialize: ->
        itemspot: @itemspot.toViewJSON()
