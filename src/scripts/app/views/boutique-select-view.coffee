
class App.Views.BoutiqueSelect extends Backbone.LayoutView

    template: 'boutique-select'
    className: 'content boutique-select-view'

    events:
        'vclick #navigate-to-boutique-button': 'navigateToBoutique'

    onEmptyBoutiqueCode: ->
        alert "Please enter a boutique code."

    onBoutiqueCodeNotFound: (boutiqueCode) ->
        alert "Boutique '#{boutiqueCode}' wasn't found. Try again :)"

    getBoutiqueCode: ->
        (@$el.find '#boutique-code').val()

    navigateToBoutique: (event) ->
        event.preventDefault()

        boutiqueCode = @getBoutiqueCode()
        return @onEmptyBoutiqueCode() if not boutiqueCode

        App.collections.boutiques.getOrCreateFromCode boutiqueCode,
            notFound: =>
                @onBoutiqueCodeNotFound boutiqueCode
            success: (boutique) =>
                App.router.navigate boutique.getRouterUrl(), {trigger:true}

        return false

# class App.Views.BoutiqueSelectBarcodeScanner extends Backbone.LayoutView


    # :coffeescript
    #     getBoutiqueExistsUrl = (boutiqueCode) ->
    #         "/boutiques/" + boutiqueCode + "/exists/"


    #     getBoutiqueUrl = (boutiqueCode) ->
    #         "/boutiques/" + boutiqueCode


    #     getAdspotUrl = (boutiqueCode, adspotIndex) ->
    #         (getBoutiqueUrl boutiqueCode) + '/items/' + adspotIndex + '/'


    #     displayErrorMessage = (message) ->
    #         $('.control-group').addClass 'error'
    #         $('.error-message').text message


    #     handleScannedItem = (data) ->
    #         tokens = data.split '#'

    #         if tokens.length isnt 2
    #             return alert 'Could not parse the scanned data. Please try again.'

    #         [boutiqueCode, adspotIndex] = tokens
    #         adspotUrl = getAdspotUrl boutiqueCode, adspotIndex
    #         console.log "Scan successful: BoutiqueCode[#{boutiqueCode}], AdspotIndex[#{adspotIndex}]"

    #         $.ajax
    #             type: 'GET'
    #             url: adspotUrl
    #             success: ->
    #                 showLoadingModal 'Loading Boutique'
    #                 window.location = adspotUrl
    #             error: ->
    #                 alert "Could not find scanned item. Please try again."


    #     loadingModal = do ->

    #         makeSpinner = ->
    #             opts =
    #                 lines: 9
    #                 length: 3
    #                 width: 3
    #                 radius: 10
    #                 corners: 1
    #                 rotate: 0
    #                 color: '#f2f2f2'
    #                 speed: 1.4
    #                 trail: 100
    #                 shadow: false
    #                 hwaccel: false
    #                 className: 'spinner'
    #                 zIndex: 2e9
    #                 top: 'auto'
    #                 left: 'auto'

    #             spinner = (new Spinner opts)

    #         (container, text) ->
    #             $container = $(container)
    #             throw "Invalid container " + container + "." if $container.length is 0

    #             $container.empty()

    #             $loadingModal = $('<div class="loading-modal" />')
    #             $loadingModal.hide()

    #             $text = $('<p class="text">' + text + '</p>')
    #             $loadingModal.append $text

    #             $spinWrap = $('<div class="spin-wrap" />')
    #             $loadingModal.append $spinWrap

    #             setTimeout(->
    #                 spinner = makeSpinner()
    #                 spinner.spin $spinWrap[0]
    #             , 0)

    #             $container.append $loadingModal

    #             show: -> $loadingModal.show()
    #             hide: -> $loadingModal.hide()


    #     showLoadingModal = (text) ->
    #         modal = (loadingModal '.loading-modal-wrapper', text)
    #         modal.show()


    #     $('#boutique-code-button').on 'vclick', ->
    #         code = $('#id_code').val()

    #         if not code
    #             displayErrorMessage 'Whoops, you forgot to enter a code!'
    #             return false

    #         $('input:focus').blur()

    #         $.ajax
    #             type: 'GET'
    #             url: getBoutiqueExistsUrl code
    #             success: ->
    #                 showLoadingModal 'Loading Boutique'
    #                 window.location = getBoutiqueUrl code
    #             error: ->
    #                 displayErrorMessage "This code doesn't exist, please try again :)"

    #         return false


    #     $ ->
    #         console.log $('.content').height()
    #         if isPhonegap()
    #             $('.phonegap-only').show()

    #             $('#scan-barcode-button').click ->
    #                 window.communicator.postMessage 'scanBarcode', (err, result) ->
    #                     return alert "Scanning failed: #{err}" if err
    #                     return alert 'The user cancelled the scan.' if result.cancelled
    #                     handleScannedItem result.text
