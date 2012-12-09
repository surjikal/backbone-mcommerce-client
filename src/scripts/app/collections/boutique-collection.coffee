
class App.Collections.Boutique extends Backbone.Collection

    model: App.Models.Boutique

    getOrCreateFromCode: (boutiqueCode, callbacks) ->
        normalizedBoutiqueCode = boutiqueCode.toLowerCase()
        boutique = @get normalizedBoutiqueCode
        return callbacks.success boutique if boutique

        boutique = new App.Models.Boutique {code: normalizedBoutiqueCode}
        boutique.fetch
            error: ->
                callbacks.notFound boutiqueCode
            success: (boutique) =>
                @push boutique
                callbacks.success boutique
