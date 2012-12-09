
class App.Views.WizardStepListItem extends Backbone.LayoutView

    tagName: 'li'
    className: 'restrict-width wizard-list-item'

    initialize: (options) ->
        @step = options.step
        @eventDispatcher = options.eventDispatcher

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


class App.Views.WizardStep extends App.Views.FormView

    events:
        'vclick #wizard-next-step': 'wizardNextStepClicked'

    constructor: ->
        # You need to put something with the id `wizard-next-step` in your template.
        super

    initialize: (options) ->
        super options
        @step            = options._step
        @eventDispatcher = options._eventDispatcher

        # If the step defines dependencies, throw an error when the options don't
        # contain them. This is for a runtime assertion, aka when the developer is testing.
        if @dependencies
            availableData = (key for key, value of options.wizardData when Boolean(value))
            unmetDependencies = _.difference @dependencies, availableData
            if not _.isEmpty unmetDependencies
                throw new Error "Dependencies '[#{unmetDependencies.join(', ')}]' not met for wizard step '#{@step.id}'."

    wizardNextStepClicked: (event) ->
        event.preventDefault()
        @beforeNextStep (data = {}) =>
            @completed data
        return false

    _addUrlParameter: (key, value) ->
        @eventDispatcher.trigger 'addUrlParameter', {@step, parameter:{key, value}}

    beforeNextStep: (done) ->
        done()

    completed: (data) ->
        @step.state = 'complete'
        @eventDispatcher.trigger 'step:completed', {data, @step}



class App.Views.WizardStepList extends Backbone.LayoutView

    tagName: 'ol'
    className: 'wizard-steps'

    initialize: (options) ->
        @steps           = options.steps
        @eventDispatcher = options.eventDispatcher

        @eventDispatcher.on 'step:completed', =>
            @render()

    beforeRender: ->
        _.each @steps, (step) =>
            view = new App.Views.WizardStepListItem {step, @eventDispatcher}
            view.setPercentageWidth (100 / @steps.length)
            @insertView view


# TODO: Refactor; separate view and controller. Add step model and collection.
class App.Views.Wizard extends Backbone.LayoutView

    template: 'wizard'

    # This data object is modified every time a step is done, and is
    # injected into the current step when it is shown. When the wizard
    # is completed, the collected data is passed to the derived class.
    _data: {}

    initialize: (options) ->
        console.debug 'Initializing wizard.'

        steps = @steps or options.steps
        throw new Error "Wizard has no steps." if not steps

        @initializeEventDispatcher()

        @steps     = @createSteps steps, @eventDispatcher
        @stepOrder = @createStepOrder @steps
        @stepIdMap = @createStepIdMap @steps

        if options.step
            console.debug "Starting wizard at step '#{options.step}'."

            if not (options.step in @stepOrder)
                throw new Error "Initial step '#{options.step.id}' not found in steps #{@steps.join ', '}'."

            # Set all the previous steps to the completed state
            stepIndex = @stepOrder.indexOf options.step
            for step in @steps[..stepIndex]
                console.debug "Completing step '#{step.id}'."
                step.state = 'complete'

        initialStepId = options.step or @getFirstStepId()

        if options.wizardData
            console.debug "Preloading wizard with data:\n", options.wizardData
            @_data = options.wizardData

        @setStep initialStepId, @_data

        @initStepListView()

    # Creates an events object which will be passed to all wizard steps.
    initializeEventDispatcher: ->
        @eventDispatcher = _.extend {}, Backbone.Events
        @eventDispatcher.on 'step:completed', ({data, step}) =>
            @stepCompleted data, step
        @eventDispatcher.on 'addUrlParameter', ({step, parameter}) =>
            search = window.location.search
            separator = if not search then '?' else '&'
            @_setUrl "#{@getStepUrl step.id}#{window.location.search}#{separator}#{parameter.key}=#{parameter.value}"

    createSteps: (steps, eventDispatcher) ->
        _.map steps, (step, index) =>
            step._createView = step.initialize
                _eventDispatcher:eventDispatcher
                _step:step
            step._index      = index
            step.state       = ''
            step

    createStepOrder: (steps) ->
        _.pluck steps, 'id'

    createStepIdMap: (steps) ->
        stepIdMap = {}
        stepIdMap[step.id] = step for step in steps
        stepIdMap

    initStepListView: ->
        stepListView = new App.Views.WizardStepList {@steps, @eventDispatcher}
        @setView '#wizard-step-list', stepListView

    getFirstStepId: ->
        _.first @stepOrder

    getStepObject: (id) ->
        return @stepIdMap[id] or do ->
            throw (new Error "Step '#{id}' not found.")

    getStepIdAt: (index) ->
        @stepOrder[index]

    getNextStepId: (id) ->
        step = @getStepObject id
        nextIndex = step._index + 1
        return console.debug "Already at last step." if nextIndex >= @stepOrder.length
        @getStepIdAt nextIndex

    setStep: (id, data, render = false) ->
        console.debug "Setting wizard to '#{id}' step."
        step = @getStepObject id
        @_resetIncompleteStepStates()
        @_setUrl "#{@getStepUrl id}#{window.location.search}"
        step.state = 'active'
        stepView = step._createView data
        @setView '#wizard-step', stepView
        stepView.render() if render

    stepCompleted: (data, step) ->
        nextStepId = @getNextStepId step.id
        @_data = _.extend @_data, data
        return @setStep nextStepId, @_data, true if nextStepId
        @completed @_data

    # Implement this in your derived class
    completed: (data) ->
        console.warn 'Wizard completed, but derived class is not handling it.'
        console.debug data

    # Resetting all step states to be normal if they are not complete.
    _resetIncompleteStepStates: ->
        @steps = _.map @steps, (step, index) ->
            step.state = '' if step.state isnt 'complete'
            step

    _setUrl: (url) ->
        App.router.navigate url, {trigger: false, replace: true}
