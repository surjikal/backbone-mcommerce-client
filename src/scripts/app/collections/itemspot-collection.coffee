
class App.Collections.ItemSpot extends App.Collections.Base

    model: App.Models.ItemSpot

    comparator: (itemspot) ->
        itemspot.get 'index'
