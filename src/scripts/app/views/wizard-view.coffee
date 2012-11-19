
class App.Views.WizardStepListItem extends Backbone.LayoutView

    tagName: 'li'
    className: 'restrict-width wizard-list-item'

    initialize: (options) ->
        @step = options.step
        @dispatcher = options.dispatcher

    setPercentageWidth: (width) ->
        @$el.css 'width', "#{width}%"

    getIcon: ->
        if @step.state is 'complete' then 'checkmark' else @step.icon

    beforeRender: ->
        @$el.text @step.title
        @$el.removeClass()
        @$el.addClass @className
        @$el.addClass "#{@getIcon()}-icon"
        @$el.addClass "#{@step.state or ''}"


class App.Views.WizardStepList extends Backbone.LayoutView

    tagName: 'ol'
    className: 'wizard-steps'

    initialize: (options) ->
        @steps = options.steps
        @dispatcher = options.dispatcher

        @dispatcher.on 'step:completed', (stepMessage) =>
            @steps[stepMessage.step.index]?.state = 'complete'
            @render()

    beforeRender: ->
        _.each @steps, (step) =>
            view = new App.Views.WizardStepListItem {step, @dispatcher}
            view.setPercentageWidth (100 / @steps.length)
            @insertView view


class App.Views.WizardStep extends App.Views.FormView

    initialize: (options) ->
        super options
        @step       = options.step
        @dispatcher = options.dispatcher

    cancelled: ->
        @dispatcher.trigger 'step:cancelled', {@step}

    completed: (data = {}) ->
        @dispatcher.trigger 'step:completed', {data, @step}


class App.Views.Wizard extends Backbone.LayoutView

    template: 'wizard'

    # events:
        # 'click #cancel-wizard': 'cancelWizardClicked'
        # 'click .wizard-list-item': 'listItemClicked'
        # 'click #wizard-next-step': 'showNextStep'

    data: []

    initialize: (options) ->
        @initializeEventDispatcher()

        @steps = _.map options.steps, (step, index) =>
            step.index = index
            step.view = new step.viewClass (_.extend options, {@dispatcher, step})
            step

        @stepList = new App.Views.WizardStepList {@steps, @dispatcher}
        @_setStepIndex (options.initialStep or 0)
        @setView '#wizard-step-list', @stepList

        @initializeEventDispatcher()

    initializeEventDispatcher: ->
        @dispatcher = _.extend {}, Backbone.Events
        @dispatcher.on 'step:completed', (message) =>
            @handleStepCompleted message

    showStep: (stepIndex) ->
        return console.debug "Already at first step, can't go back." if stepIndex <= 0
        return @completed @data if stepIndex >= @steps.length

        console.debug "Switching to wizard step ##{stepIndex}."
        @_setStepIndex stepIndex
        @render()

    showNextStep: ->
        nextStepIndex = @stepIndex + 1
        if nextStepIndex is @steps.length
            # you're done, do something
            return console.log 'Done!'
        @showStep nextStepIndex

    handleStepCompleted: (message) ->
        index = message.step.index
        @data[index] = message
        @showStep index+1

    _setStepIndex: (stepIndex) ->

        # Resetting all step states to be normal if they are not complete.
        @steps = _.map @steps, (step, index) ->
            step.state = '' if step.state isnt 'complete'
            step

        step = @steps[stepIndex]

        throw "Wizard step ##{stepIndex} not found." if not step

        step.state = 'active'
        @setView '#wizard-step', step.view

        step










