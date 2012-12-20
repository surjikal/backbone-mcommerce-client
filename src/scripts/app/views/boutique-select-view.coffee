
class App.Views.BoutiqueSelect extends App.Views.FormView

    template: 'boutique-select'
    className: 'content boutique-select-view'

    events:
        'click #navigate-to-boutique-button': 'navigateToBoutiqueButtonClicked'
        'click #scan-button':                 'scanButtonClicked'

    onEmptyBoutiqueCode: ->
        @errorAlert "Please enter a boutique code."

    onBoutiqueCodeNotFound: (boutiqueCode) ->
        @errorAlert "Boutique '#{boutiqueCode}' wasn't found. Try again :)"

    getBoutiqueCode: ->
        (@$el.find '#boutique-code').val()

    navigateToBoutiqueButtonClicked: (event) ->
        event.preventDefault()
        boutiqueCode = @getBoutiqueCode()
        return @onEmptyBoutiqueCode() if not boutiqueCode
        @navigateToBoutique boutiqueCode
        return false

    navigateToBoutique: (boutiqueCode) ->
        @enablePending()
        App.router.navigate "/boutiques/#{boutiqueCode}", {trigger: true}

    navigateToItemspot: (boutiqueCode, itemspotIndex) ->
        @enablePending()
        App.router.navigate "/boutiques/#{boutiqueCode}/items/#{itemspotIndex}", {trigger: true}

    scanButtonClicked: (event) =>
        console.debug "Scan button clicked."
        @enablePending '#scan-button', 0
        controller = new App.Controllers.BarcodeScanner()
        controller.scan
            success: (boutiqueCode, itemspotIndex) =>
                @disablePending()
                @navigateToItemspot boutiqueCode, itemspotIndex
            cancelled: =>
                @disablePending()
                console.log "User cancelled barcode scanner."
            scanError: (errorMessage) =>
                @disablePending()
                console.error "Scanner error:", errorMessage
                @errorAlert "Something went wrong with the scanner. Please, try again!"
            parseError: (scannedData) =>
                @disablePending()
                console.error "Could not parse scanned data. Data:", scannedData
                @errorAlert "I couldn't read the barcode :(. Please, try again!"

    serialize: ->
        phonegap: App.isPhonegap


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

    # Override this for testing
    _callScanPlugin: ->
        window.plugins.barcodeScanner.scan arguments...
