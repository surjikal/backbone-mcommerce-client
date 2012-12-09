
class App.Views.FormView extends Backbone.LayoutView

    events:
        'change input': 'inputChanged'

    initiliaze: ->
        @fields = @fields or {}

    inputChanged: (event) ->
        $input = @$el.find event.target
        $input.removeClass 'error'

    getField: (fieldName) ->
        selector = @fields[fieldName]
        @$ selector

    getFieldValue: (fieldName) ->
        (@getField fieldName).val()

    setFieldValue: (fieldName, value) ->
        (@getField fieldName).val value

    getFieldValues: (fieldNames...) ->
        fields = if _.isEmpty fieldNames then @fields \
               else _.pick @fields, fieldNames...

        _.objMap fields, (selector, name) =>
            @getFieldValue name

    setFieldErrors: (fieldNames) ->
        @setFieldError name for name in fieldNames

    setFieldError: (fieldName) ->
        (@getField fieldName).addClass 'error'

    clearFieldErrors: ->
        (@$ 'input').removeClass 'error'

    clearFieldError: ($el) ->
        $el.removeClass 'error'

    errorAlert: (message) ->
        _.defer -> alert message

    getSubmitButton: ->
        @$ 'button[type="submit"]'

    getSubmitButtonText: ->
        @getSubmitButton().text()

    setSubmitButtonText: (text) ->
        $button = @getSubmitButton()
        $button.text text

    enablePending: ->
        @pendingTimer = setTimeout( =>
            @pending = true
            $button = @getSubmitButton()
            $button.addClass 'loading'
        , 500)

    disablePending: ->
        clearTimeout @pendingTimer
        @pending = false
        $button = @getSubmitButton()
        $button.removeClass 'loading'
