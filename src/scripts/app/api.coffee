
# If you add an API here, initialize it in `app.coffee`.

class Api

    constructor: (@rootUrl) ->

    url: (action) ->
        "#{@rootUrl}/#{@resource}/#{action}/"

    post: (action, data, callbacks) ->
        url = @url action
        App.utils.json.post {url, data, callbacks}


class App.Api.Auth extends Api

    resource: 'auth'

    validate: (email, password, callbacks) ->
        @post 'validate', {email, password}, callbacks

    register: (email, password, callbacks) ->
        @post 'register', {email, password}, callbacks


class App.Api.Purchase extends Api

    resource: 'purchase'

    getToken: (address, itemspot, successUrl, cancelUrl, callbacks) ->
        address  = address.toJSON()
        boutique = code: itemspot.getBoutiqueCode()
        itemspot = index: itemspot.get 'index'

        data = {
            address
            boutique
            itemspot
            successUrl
            cancelUrl
        }

        @post 'get_token', data, callbacks

    getDetails: (token) ->
        @post 'get_details', {token}, callbacks
