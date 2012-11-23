
class App.Models.Address extends Backbone.RelationalModel

    defaults:
        firstName: null
        lastName: null
        street: null
        # city: 'Orleans'
        # province: 'Ontario'
        postalCode: null

App.Models.Address.setup()