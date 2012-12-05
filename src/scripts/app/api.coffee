
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
        data = {email, password}
        @post 'validate', data, callbacks

    register: (email, password, callbacks) ->
        data = {email, password}
        @post 'register', data, callbacks


class App.Api.Purchase extends Api

    resource: 'purchase'

    getToken: (email, address, itemspot, callbacks) ->
        data = {email, address, itemspot}
        @post 'get_token', data, callbacks
