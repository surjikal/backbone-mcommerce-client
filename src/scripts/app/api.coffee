

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
