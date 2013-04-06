
class App.Router extends Backbone.Router

    routes:
        '':                                                    'index'
        'login':                                               'login'

        'boutiques/:code':                                     'boutique'
        'boutiques/:code/notFound':                            'boutiqueNotFound'

        'boutiques/:boutiqueCode/items/:index':                'itemspot'
        'boutiques/:boutiqueCode/items/:index/checkout':       'purchaseWizard'
        'boutiques/:boutiqueCode/items/:index/checkout/:step': 'purchaseWizard'
        'boutiques/:boutiqueCode/items/:index/thanks':         'thanks'
        'boutiques/:boutiqueCode/items/:index/notFound':       'itemspotNotFound'

        '*_': 'routeNotFound'


    initialize: ->
        console.debug 'Initializing router.'


    index: ->
        App.router.navigate "/boutiques/trolley", {trigger: true}


    boutiqueSelect: ->
        console.debug 'Routing to boutique select.'
        App.views.main.setPageView new App.Views.BoutiqueSelect(), true


    login: (params) ->
        console.debug "Routing to login. Params: #{params}"
        next = params?.next or '/'
        App.views.main.setPageView new App.Views.Auth {
            callbacks: success: ->
                alert "Login success!"
        }


    boutique: (code) ->
        console.debug 'Routing to boutique.'
        getBoutiqueOrShowNotFound code, (boutique) ->
            App.views.main.setPageView new App.Views.Boutique {model: boutique}


    itemspot: (boutiqueCode, index) ->
        console.debug 'Routing to itemspot.'
        getItemSpotOrShowNotFound boutiqueCode, index, (itemspot) ->
            App.views.main.setPageView new App.Views.ItemSpot {model: itemspot}


    purchaseWizard: (boutiqueCode, index, step, params = {}) ->
        console.debug 'Routing to purchase wizard.'
        getItemSpotOrShowNotFound boutiqueCode, index, (itemspot, boutique) ->

            # Checking if the `step` parameter is there...
            if _.isObject step
                params = step
                step = null

            # If we have a step parameter, we are resuming the wizard.
            # resumingWizard = Boolean step

            showPurchaseWizard = (user, done) ->
                App.views.main.setPageView new App.Views.PurchaseWizard {user, itemspot, step, params, done}

            purchaseWizardCompleted = ->
                App.router.navigate "#{itemspot.getRouterUrl()}/thanks", {trigger: true}

            showNewUserPurchaseWizard = (user) ->
                addresses = user.getAddresses()
                addresses.fetch success: ->
                    showPurchaseWizard user, ->
                        purchaseWizardCompleted()

            fetchUserAndShowPurchaseWizard = (user) ->
                success = (user) ->
                    showPurchaseWizard user, -> purchaseWizardCompleted()

                return success user if App.config.offlineMode
                user.fetch {success}

            user = App.auth.user
            return fetchUserAndShowPurchaseWizard user if user.isLoggedIn()
            return showNewUserPurchaseWizard user      # if resumingWizard and App.auth.user.isNew()


    thanks: (boutiqueCode, index) ->
        console.debug 'Routing to thanks.'
        getItemSpotOrShowNotFound boutiqueCode, index, (itemspot) ->
            App.views.main.setPageView new App.Views.Thanks {itemspot}


    boutiqueNotFound: (code) ->
        console.log "Boutique '#{code}' was not found."
        # TODO: Show some kind of 404 view.


    itemspotNotFound: (boutiqueCode, index) ->
        console.log "ItemSpot ##{index} of boutique #{boutiqueCode} was not found."
        # TODO: Show some kind of 404 view.


    routeNotFound: (route) ->
        if route[-1..] is '/'
            console.error "Requested route '#{route}' has a trailing slash. Redirecting."
            return @navigate route[..-2], {trigger: true, replace: true}
        console.debug "Route '#{route}' not found."



# Some helpers

getBoutiqueOrShowNotFound = (boutiqueCode, success) ->
    App.collections.boutiques.getOrFetch boutiqueCode, {
        success
        notFound: ->
            App.router.navigate "/boutiques/#{boutiqueCode}/notFound", {trigger: true, replace: true}
    }


getItemSpotOrShowNotFound = (boutiqueCode, index, success) ->
    getBoutiqueOrShowNotFound boutiqueCode, (boutique) ->
        return success itemspot if itemspot = boutique.getItemSpotFromIndex index
        App.router.navigate "/boutiques/#{boutiqueCode}/items/#{index}/notFound", {trigger: true, replace: true}
