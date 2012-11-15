
class App.Models.Item extends Backbone.RelationalModel

    defaults:
        itemPrice: 0
        resourceUri: ''

    relations: [
        type: Backbone.HasOne
        key: 'item'
        relatedModel: 'App.Models.Item'
        collectionType: 'App.Collections.Item'
    ]

    url: ->
        boutiqueCode = @get 'boutiqueCode'
        index = @get 'index'
        "/boutiques/#{boutiqueCode}/item/#{index}/"
