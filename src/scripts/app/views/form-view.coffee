
PENDING_TIMEOUT = 5000


class App.Views.FormView extends Backbone.LayoutView

    initiliaze: ->
        @fields = @fields or {}

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

    enablePending: (buttonSelector) ->

        showLoadingSpinner = =>
            $button = if buttonSelector then (@$ buttonSelector) else @getSubmitButton()
            $button.addClass 'loading'

        @pending = true
        showLoadingSpinner()
        @pendingTimer = setTimeout @onPendingTimeout, PENDING_TIMEOUT

    onPendingTimeout: =>
        @disablePending()
        @errorAlert 'The server is not responding :(. Please try again.'

    disablePending: ->
        clearTimeout @pendingTimer
        @pending = false
        (@$ '.loading')?.removeClass 'loading'

    cleanup: ->
        console.debug 'Cleaning up form view.'
        @disablePending()
