
class App.Collections.Boutique extends Backbone.Collection

    model: App.Models.Boutique

    getOrCreateFromCode: (boutiqueCode, callbacks) ->
        boutiqueCode = boutiqueCode.toLowerCase()
        boutique     = @get boutiqueCode

        return callbacks.success boutique if boutique

        boutique = new App.Models.Boutique {code: boutiqueCode}
        boutique.fetch
            error: =>
                boutique.destroy()
                callbacks.notFound boutiqueCode

            success: (boutique) =>
                @push boutique
                callbacks.success boutique
