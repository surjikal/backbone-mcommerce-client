
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
        @boutiqueSelect()


    boutiqueSelect: ->
        console.debug 'Routing to boutique select.'
        App.views.main.setPageView new App.Views.BoutiqueSelect(), true


    login: (params) ->
        console.debug "Routing to login. Params: #{params}"
        next = params?.next or '/'
        model = App.models.user
        App.views.main.setPageView new App.Views.Auth {
            model,
            callbacks: success: (user) ->
                App.models.user = user
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

            showPurchaseWizard = (user) ->
                App.views.main.setPageView new App.Views.PurchaseWizard {user, itemspot, step, params}

            showNewUserPurchaseWizard = (user) ->
                addresses = user.getAddresses()
                addresses.localStorage = new Backbone.LocalStorage 'AddressCollection'
                addresses.url = null

                # FIXME: There's a problem with this... Here's how to reproduce:
                #
                # 0. Comment out the `window.location.href = ...` line in `App.auth._logout`
                # 1. Log in
                # 2. Log out
                # 3. Go to this route (i.e. click the checkout button in item view)
                #
                # You'll get something like:
                # 'Uncaught Error: A "url" property or function must be specified'
                #
                # Not sure how to fix it, so the workaround is to refresh the app when logging
                # out.
                addresses.fetch success: ->
                    showPurchaseWizard user

            fetchUserAndShowPurchaseWizard = (user) ->
                user.fetch success: (user) ->
                    showPurchaseWizard user

            return fetchUserAndShowPurchaseWizard App.auth.user if App.auth.user.isLoggedIn()
            return showNewUserPurchaseWizard App.auth.user      # if resumingWizard and App.auth.user.isNew()

            # console.debug "Starting guest purchase wizard; showing popup."

            # We are starting the wizard, so show the popup.
            # App.views.main.showPopup new App.Views.LoginOrNewUserPopup
            #     model: App.auth.user
            #     callbacks:
            #         # The "new user" button is clicked.
            #         newUserSuccess: (user) ->
            #             App.views.main.removePopup()
            #             showNewUserPurchaseWizard user
            #         # The user logs in.
            #         loginSuccess: (user) ->
            #             App.views.main.removePopup()
            #             fetchUserAndShowPurchaseWizard user
            #         # The popup is closed, i.e. the 'x' button is clicked.
            #         closed: ->
            #             window.history.back()


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
            return @navigate route[..-2], {trigger: true}
        console.debug "Route '#{route}' not found."

    __debug_registration: ->
        console.debug App.Views
        App.views.main.showPopup new App.Views.RegistrationPopup()


# Some helpers

getBoutiqueOrShowNotFound = (boutiqueCode, success) ->
    App.collections.boutiques.getOrCreateFromCode boutiqueCode, {
        success
        notFound: ->
            App.router.navigate "/boutiques/#{boutiqueCode}/notFound", {trigger: true}
    }

getItemSpotOrShowNotFound = (boutiqueCode, index, success) ->
    getBoutiqueOrShowNotFound boutiqueCode, (boutique) ->
        itemSpot = boutique.getItemSpotFromIndex index
        return (success itemSpot) if itemSpot
        App.router.navigate "/boutiques/#{boutiqueCode}/items/#{index}/notFound", {trigger: true}