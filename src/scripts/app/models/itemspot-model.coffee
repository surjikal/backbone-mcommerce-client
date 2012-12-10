
class App.Models.ItemSpot extends Backbone.RelationalModel

    getBoutiqueCode: ->
        boutique = @get 'boutique'
        boutique.get 'code'

    getCheckoutUrl: ->
        "#{@getRouterUrl()}/checkout"

    getRouterUrl: ->
        index = @get 'index'
        code  = @getBoutiqueCode()
        "boutiques/#{code}/items/#{index}"

    getImageUrl: ->
        item = @get 'item'
        "#{App.config.urls.static}/images/#{item.image}"

    toViewJSON: (boutiqueCode) ->
        _.extend @toJSON(),
            image: @getImageUrl()
            url:   @getRouterUrl()

    url: ->
        index = @get 'index'
        code  = @getBoutiqueCode()
        "#{App.config.urls.api}/boutiques/#{code}/itemspots/#{index}"