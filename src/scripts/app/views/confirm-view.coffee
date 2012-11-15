
class App.Views.Confirm extends App.Views.FormView

    template: 'confirm'
    className: 'content confirm'

    events:
        'click #wizard-next-step': 'wizardNextStepClicked'

    wizardNextStepClicked: ->
        return false

    serialize: ->
        item:
            name: 'Bacon'
            price: 2
        bill:
            shipping: 0
            tax: 10
            total: 12