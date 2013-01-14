
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
        return item.image if App.config.offlineMode
        "#{App.config.urls.static}/images/#{item.image}"

    getStats: ->
        views = App.utils.getRandomInteger 0, 10000
        likes = App.utils.getRandomInteger 0, views
        {views, likes}

    toViewJSON: (boutiqueCode) ->
        _.extend @toJSON(),
            image: @getImageUrl()
            url:   @getRouterUrl()
            stats: @getStats()

    url: ->
        index = @get 'index'
        code  = @getBoutiqueCode()
        "#{App.config.urls.api}/boutiques/#{code}/itemspots/#{index}"