
LOADING_TIMEOUT = 2000


class App.Views.FormView extends Backbone.LayoutView

    events:
        'submit': -> false

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

    enablePending: (buttonSelector, timeout = LOADING_TIMEOUT) ->

        if _.isNumber buttonSelector
            timeout        = buttonSelector
            buttonSelector = null

        showLoadingSpinner = =>
            $button = if buttonSelector then (@$ buttonSelector) else @getSubmitButton()
            $button.addClass 'loading'

        @pending = true
        showLoadingSpinner()

        if timeout >= 0
            @pendingTimer = setTimeout @onPendingTimeout, timeout

    onPendingTimeout: =>
        @disablePending()
        @errorAlert 'The server is not responding :(. Please try again.'

    disablePending: ->
        clearTimeout @pendingTimer
        @pending = false
        @$('.loading')?.removeClass 'loading'

    cleanup: ->
        console.debug 'Cleaning up form view.'
        @disablePending()

    withLoadingSpinner: (event) => ({target, timeout, onEvent, onTimeout}) =>

        timeout = LOADING_TIMEOUT if not timeout
        getTargetEl = if target then (=> @$(target)) else @getSubmitButton

        isLoading = false
        timer     = null

        startLoading = ->
            timer = initTimer() if timeout >= 0
            isLoading = true
            $target = getTargetEl()
            $target.addClass 'loading'

        stopLoading = ->
            clearTimeout timer
            isLoading = false
            $target = getTargetEl()
            $target.removeClass 'loading'

        _onTimeout = =>
            stopLoading()
            if onTimeout then onTimeout.call @ \
                         else @errorAlert 'The server is not responding :(. Please try again.'

        initTimer = =>
            setTimeout _onTimeout, timeout

        return false if isLoading
        onEvent.call @, startLoading, stopLoading
