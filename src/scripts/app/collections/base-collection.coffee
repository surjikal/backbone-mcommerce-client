
class App.Collections.Base extends Backbone.Collection

    # Callbacks:
    # - success:  the boutique was found
    # - notFound: the boutique with the specified code was not found
    getOrFetch: (modelId, {success, notFound}) ->

        return success model if (model = @get modelId)

        model = new @model
        model.set model.idAttribute, modelId
        model.fetch
            error: =>
                notFound modelId
            success: =>
                @push model
                success model
