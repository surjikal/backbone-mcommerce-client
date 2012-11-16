
class App.Models.ItemSpot extends Backbone.RelationalModel

    getBoutiqueCode: ->
        boutique = @get 'boutique'
        boutique.get 'code'

    toViewJSON: (boutiqueCode) ->
        _.extend @toJSON(),
            image: @getImageUrl()
            url:   @getRouterUrl()

    getRouterUrl: ->
        index = @get 'index'
        code  = @getBoutiqueCode()
        "/boutiques/#{code}/items/#{index}"

    getImageUrl: ->
        item = @get 'item'
        "#{App.config.urls.static}/images/#{item.image}"
