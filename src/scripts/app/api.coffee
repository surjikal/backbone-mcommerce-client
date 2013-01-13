
# If you add an API here, initialize it in `app.coffee`.


class App.Api

    initialize: (@baseUrl) ->
        @auth     = new App.Api.Auth     @baseUrl
        @purchase = new App.Api.Purchase @baseUrl


class Api

    constructor: (@baseUrl) ->

    url: (action) ->
        "#{@baseUrl}/#{@resource}/#{action}/"

    post: (action, data, callbacks) ->
        url = @url action

        options = {url, data, callbacks}
        options.auth = "Basic #{App.auth.token}" if App.auth.isLoggedIn

        App.utils.json.post options


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
