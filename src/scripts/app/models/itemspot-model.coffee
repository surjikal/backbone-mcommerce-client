
class App.Models.ItemSpot extends Backbone.RelationalModel

    url: ->
        boutiqueCode = @get 'boutiqueCode'
        index = @get 'index'
        "/boutiques/#{boutiqueCode}/item/#{index}/"
