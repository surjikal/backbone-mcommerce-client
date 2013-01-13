
class App.Views.BoutiqueSelect extends App.Views.FormView

    template: 'boutique-select'
    className: 'content boutique-select-view'

    events:
        _.extend {}, App.Views.FormView::events,
            'click #navigate-to-boutique-button': 'navigateToBoutiqueButtonClicked'
            'click #scan-button':                 'scanButtonClicked'

    onEmptyBoutiqueCode: ->
        @errorAlert "Please enter a boutique code."

    onBoutiqueCodeNotFound: (boutiqueCode) ->
        @errorAlert "Boutique '#{boutiqueCode}' wasn't found. Try again :)"

    getBoutiqueCode: ->
        (@$el.find '#boutique-code').val()

    navigateToBoutiqueButtonClicked: (event) => (@withLoadingSpinner event)
        onEvent: (startLoading, stopLoading) =>
            event.preventDefault()

            return @onEmptyBoutiqueCode() if not (boutiqueCode = @getBoutiqueCode())
            startLoading()

            App.collections.boutiques.getOrFetch boutiqueCode,
                success: (boutique) =>
                    stopLoading()
                    @navigateToBoutique boutique
                notFound: =>
                    stopLoading()
                    @onBoutiqueCodeNotFound boutiqueCode

    navigateToBoutique: (boutique) ->
        boutiqueCode = boutique.get 'code'
        App.router.navigate "/boutiques/#{boutiqueCode}", {trigger: true}

    navigateToItemspot: (boutiqueCode, itemspotIndex) ->
        App.router.navigate "/boutiques/#{boutiqueCode}/items/#{itemspotIndex}", {trigger: true}

    scanButtonClicked: (e) => (@withLoadingSpinner e)
        target: '#scan-button'
        timeout: -1

        onEvent: (startLoading, stopLoading) ->
            startLoading()

            controller = new App.Controllers.BarcodeScanner()
            controller.scan
                success: (boutiqueCode, itemspotIndex) =>
                    App.collections.boutiques.getOrFetch boutiqueCode,
                        success: =>
                            stopLoading()
                            @navigateToItemspot boutiqueCode, itemspotIndex
                        notFound: =>
                            stopLoading()
                            @onBoutiqueCodeNotFound boutiqueCode
                cancelled: =>
                    stopLoading()
                    console.log "User cancelled barcode scanner."
                scanError: (errorMessage) =>
                    stopLoading()
                    console.error "Scanner error:", errorMessage
                    @errorAlert "Something went wrong with the scanner. Please, try again!"
                parseError: (scannedData) =>
                    stopLoading()
                    console.error "Could not parse scanned data. Data:", scannedData
                    @errorAlert "I couldn't read the barcode :(. Please, try again!"


class App.Controllers.BarcodeScanner

    # Callbacks:
    # - success:    scan & parse success, returns boutiqueCode and itemspotIndex
    # - cancelled:  user cancelled the scan
    # - scanError:  the plugin derped
    # - parseError: the scanned data could not be parsed
    scan: ({success, cancelled, parseError, scanError}) ->
        @_scan {
            cancelled,
            error: scanError,
            success: (data, type) =>
                console.debug "Scan success (#{type}):", data
                @_parseScannedData data, {success, parseError}
        }

    # Callbacks:
    # - success:    scan success, returns data and type
    # - cancelled:  user cancelled the scan
    # - error:      the plugin derped
    _scan: ({success, cancelled, error}) ->

        onScanSuccess = (result) =>
            return cancelled?() if result.cancelled
            success? result.text, result.type

        onScanError = (errorMessage) ->
            error? errorMessage

        _.defer =>
            @_callScanPlugin onScanSuccess, onScanError

    # Callbacks:
    # - success: parse success, returns boutiqueCode and itemspotIndex
    # - error:   the scanned data could not be parsed
    _parseScannedData: (scannedData, {success, error}) ->
        tokens = scannedData.split '#'

        if tokens.length isnt 2
            return error? scannedData

        [boutiqueCode, itemspotIndex] = tokens
        success? boutiqueCode, itemspotIndex

    _callScanPlugin: ->
        window.plugins.barcodeScanner.scan arguments...


class App.Controllers.MockBarcodeScanner

    scan: ({success, cancelled, parseError, scanError}) ->
        success? 'vipl', 5
