
class App.Router extends Backbone.Router

    # If you change these, don't forget to update the corresponding model url!
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
        @mainLayoutController = new App.MainLayoutController()


    index: ->
        @boutiqueSelect()


    boutiqueSelect: ->
        console.debug 'Routing to boutique select.'
        @mainLayoutController.setPageView new App.Views.BoutiqueSelect(), true


    login: (params) ->
        console.debug "Routing to login. Params: #{params}"
        next = params?.next or '/'
        @mainLayoutController.setPageView new App.Views.Auth {next}


    logout: ->
        console.debug 'Routing to logout.'
        App.auth.logout
            error: ->
                console.debug "Logout was not successful."
                console.debug arguments
            success: ->
                console.debug "Logout success!"


    boutique: (code) ->
        App.collections.boutiques.getOrCreateFromCode code,
            notFound: ->
                console.error "Boutique '#{code}' not found."
            success: (boutique) =>
                console.debug "Routing to boutique '#{code}'."
                @mainLayoutController.setPageView new App.Views.Boutique {model: boutique}


    itemspot: (boutiqueCode, index) ->
        console.debug 'Routing to itemspot.'
        App.collections.boutiques.getOrCreateFromCode boutiqueCode,
            notFound: ->
                console.error "Boutique '#{code}' not found."
            success: (boutique) =>
                itemSpot = boutique.getItemSpotFromIndex index
                @mainLayoutController.setPageView new App.Views.ItemSpot {model: itemSpot}


    purchaseWizard: (boutiqueCode, index) ->
        console.debug 'Routing to purchase wizard.'

        showShippingView = (boutiqueCode, index, addresses) =>
            @mainLayoutController.setPageView new App.Views.PurchaseWizard {boutiqueCode, index, addresses}

        App.models.user.addresses.fetch
            error: (addresses, response) ->
                console.warn "Error occured while fetching address collection."
                showShippingView boutiqueCode, index, addresses
            success: (addresses, response) ->
                showShippingView boutiqueCode, index, addresses

    thanks: (boutiqueCode, index) ->
        console.debug 'Routing to thanks.'
        @mainLayoutController.setPageView new App.Views.Thanks {boutiqueCode, index}


    routeNotFound: (route) ->
        if route[-1..] is '/'
            console.error "Requested route '#{route}' has a trailing slash. Redirecting."
            return @navigate route[..-2]
        console.debug "Route '#{route}' not found."

    __debug_csrf: ->
        console.debug "[DEBUG] CSRF Token: #{$.cookie 'csrftoken'}"

    __debug_popup: ->
        console.debug App.Views
        @mainLayoutController.setPageView new App.Views.LoginOrNewUserPopup()



class App.MainLayoutController

    header: null

    constructor: ->
        @mainLayout = new App.Layouts.Main()

    setPageView: (page, removeHeader = false) ->
        if removeHeader then @removeHeader() else @attachHeader()
        @mainLayout.setView '#page', page
        page.render()

    attachHeader: ->
        return if @header
        @header = new App.Views.Header()
        @mainLayout.setView '#header', @header
        @header.render()

    removeHeader: ->
        @header?.remove()
        @header = null

