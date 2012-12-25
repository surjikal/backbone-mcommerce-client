
module.exports =

    urls:
        root:   '/'
        api:    'http://localhost:9000/api'
        static: 'http://localhost:9000/static'

        paypal:
            base: 'https://www.sandbox.paypal.com'

    useStripe: true

    paypal:
        # Don't actually open the paypal checkout flow. Just pretend.
        # It will show a popup instead, and will move to the next wizard
        # step when you click the 'ok' button. This is useful when you
        # don't a paypal sandbox account.
        useMockController: true

    stripe:
        key: '12345'

    cardio:
        key: 'c6b9e2b63a5d42c4945ab3faf2f1641f'
