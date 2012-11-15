
# Virtual Plaza Client

## Dependencies

name          | url
--------------|-----------------------------------
Node.js + NPM | http://nodejs.org/
Compass       | http://compass-style.org/
CoffeeScript  | http://coffeescript.org/
Grunt         | https://github.com/gruntjs/grunt


### Installation

1. Install **Node.js** and **Compass**.
2. Run `npm install grunt -g` to install **Grunt**.
3. Run `npm install coffee-script -g` to install **CoffeeScript**.
4. Run `npm install -d` to install the node dependencies.
5. Run `./fetch-libs.sh` to fetch the third party client-side JS libraries.
6. Run `grunt` to compile and package up the application.
7. Done!


## Running the app

To run the application, use the `grunt run` command. This will open up a
server listening on port 8000, and will recompile the app when you change
a source file.


## Misc

### Grunt Server Middleware Hack

Include this middleware in the grunt server (`/node_modules/grunt/tasks/server.js`)
to let our app router handle requests as opposed to the node server.

More concretely, say you navigate to `/boutiques/vipl` instead of `/`. Instead of
showing you a `404`, this middleware will serve the index file, which lets the
backbone router handle the url.

    function(req, res, next) {
        var isAjaxRequest  = 'x-requested-with' in req.headers;
        var requestingRoot = (req.url === '/');
        var isAssetRequest = /\/assets\/.*/.test(req.url);

        if (!(isAjaxRequest || requestingRoot || isAssetRequest)) {
            req.url = '/';
        }

        return next();
    }
