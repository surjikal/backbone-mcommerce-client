
class App.Router extends Backbone.Router

    routes:
        '':                                              'index'
        'login':                                         'login'
        'logout':                                        'logout'

        'boutiques/:code':                               'boutique'
        'boutiques/:code/notFound':                      'boutiqueNotFound'

        'boutiques/:boutiqueCode/items/:index':          'itemspot'
        'boutiques/:boutiqueCode/items/:index/checkout': 'purchaseWizard'
        'boutiques/:boutiqueCode/items/:index/thanks':   'thanks'
        'boutiques/:boutiqueCode/items/:index/notFound': 'itemspotNotFound'

        'debug/registration': '__debug_registration'

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
        App.views.main.setPageView new App.Views.Auth {next}


    logout: ->
        # TODO: This shouldn't be a route, because it doesn't show a view.
        console.debug "Logging out user."
        App.auth.logout()


    boutique: (code) ->
        console.debug 'Routing to boutique.'
        getBoutiqueOrShowNotFound code, (boutique) ->
            App.views.main.setPageView new App.Views.Boutique {model: boutique}


    itemspot: (boutiqueCode, index) ->
        console.debug 'Routing to itemspot.'
        getItemSpotOrShowNotFound boutiqueCode, index, (itemspot) ->
            App.views.main.setPageView new App.Views.ItemSpot {model: itemspot}


    purchaseWizard: (boutiqueCode, index) ->
        console.debug 'Routing to purchase wizard.'
        getItemSpotOrShowNotFound boutiqueCode, index, (itemspot) ->

            showPurchaseWizard = (boutiqueCode, index, addresses) ->
                # TODO: Use itemspot as params to purchase wizard.
                App.views.main.setPageView new App.Views.PurchaseWizard {boutiqueCode, index, addresses}

            popupCallbacks =
                # The "new user" button is clicked.
                newUserSuccess: (user) ->
                    App.views.main.removePopup()
                    showPurchaseWizard boutiqueCode, index, user.addresses
                # The user logs in.
                loginSuccess: (user) ->
                    App.views.main.removePopup()
                    fetchAddresses user
                # The popup is cancelled, i.e. the 'x' button is clicked.
                closed: ->
                    App.router.navigate "boutiques/#{boutiqueCode}/items/#{index}", {trigger: true}

            showLoginOrNewUserPopup = ->
                App.views.main.showPopup new App.Views.LoginOrNewUserPopup {callbacks: popupCallbacks}

            fetchAddresses = (user) ->
                user.addresses.fetch
                    unauthorized: ->
                        # This means that we thought we were logged in but we werent.
                        console.warn "[POTENTIAL AUTH BUG] Unauthorized to fetch addresses."
                        showLoginOrNewUserPopup()
                    error: (addresses) ->
                        # TODO: Show network error popup?
                    success: (addresses) ->
                        showPurchaseWizard boutiqueCode, index, addresses

            return showLoginOrNewUserPopup() if not App.auth.isLoggedIn
            fetchAddresses App.models.user


    thanks: (boutiqueCode, index) ->
        console.debug 'Routing to thanks.'
        App.views.main.setPageView new App.Views.Thanks {boutiqueCode, index}


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
