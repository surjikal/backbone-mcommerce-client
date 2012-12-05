
# Virtual Plaza Client - Config

Override the default config by creating a `config/local.coffee` file.


----------------------

## Keys

### urls

#### root

The root url of the client-side app. This is used by the backbone router.

#### api

The base url of the vipl API. This can be relative or absolute.

#### static

The base url of vipl's static files (i.e. images).

----------------------


## Design

The **default** configuration will be extended by your **local** configuration (if present). The resulting
object will be inserted into the `App` as the `config` property.

A function in the `grunt.js` file creates the configuration object, and then passes it to the jade compiler
via the `locals` option. Then, in `index.jade` the configuration object is simply assigned to `App.config`.

