
class App.Router extends Backbone.Router

    routes:
        '':                                              'index'
        'login':                                         'login'
        'logout':                                        'logout'
        'boutiques/:code':                               'boutique'
        'boutiques/:boutiqueCode/items/:index':          'itemspot'
        'boutiques/:boutiqueCode/items/:index/checkout': 'purchaseWizard'
        'boutiques/:boutiqueCode/items/:index/thanks':   'thanks'

        'debug/csrf':  '__debug_csrf'
        'debug/popup': '__debug_popup'

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
        console.debug "Logging out user."
        App.auth.logout()


    boutique: (code) ->
        App.collections.boutiques.getOrCreateFromCode code,
            notFound: ->
                console.error "Boutique '#{code}' not found."
            success: (boutique) =>
                console.debug "Routing to boutique '#{code}'."
                App.views.main.setPageView new App.Views.Boutique {model: boutique}


    itemspot: (boutiqueCode, index) ->

        console.debug 'Routing to itemspot.'
        App.collections.boutiques.getOrCreateFromCode boutiqueCode,
            notFound: ->
                console.error "Boutique '#{code}' not found."
            success: (boutique) =>
                itemSpot = boutique.getItemSpotFromIndex index
                App.views.main.setPageView new App.Views.ItemSpot {model: itemSpot}


    purchaseWizard: (boutiqueCode, index) ->
        console.debug 'Routing to purchase wizard.'

        showPurchaseWizard = (boutiqueCode, index, addresses) ->
            App.views.main.setPageView new App.Views.PurchaseWizard {boutiqueCode, index, addresses}

        newUserSuccess = (user) ->
            App.views.main.removePopup()
            showPurchaseWizard boutiqueCode, index, user.addresses

        loginSuccess = (user) ->
            App.views.main.removePopup()
            fetchAddresses user

        cancelled = ->
            # TODO: Implement this on the popup side, and here too!

        showLoginOrNewUserPopup = ->
            App.views.main.showPopup new App.Views.LoginOrNewUserPopup
                callbacks: {cancelled, loginSuccess, newUserSuccess}

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
        fetchAddresses()


    thanks: (boutiqueCode, index) ->
        console.debug 'Routing to thanks.'
        App.views.main.setPageView new App.Views.Thanks {boutiqueCode, index}


    routeNotFound: (route) ->
        if route[-1..] is '/'
            console.error "Requested route '#{route}' has a trailing slash. Redirecting."
            return @navigate route[..-2]
        console.debug "Route '#{route}' not found."


    __debug_csrf: ->
        console.debug "[DEBUG] CSRF Token: #{$.cookie 'csrftoken'}"


    __debug_popup: ->
        console.debug App.Views
        App.views.main.showPopup new App.Views.LoginOrNewUserPopup()
