
# Virtual Plaza Client


## Main Dependencies

name          | url
--------------|-----------------------------------
Node.js + NPM | http://nodejs.org/
Compass       | http://compass-style.org/
CoffeeScript  | http://coffeescript.org/
Grunt         | https://github.com/gruntjs/grunt
Nginx         | http://wiki.nginx.org/Install


### Installation

0. Install **Node.js** and **Compass**.
1. Run `npm install grunt -g` to install **Grunt**.
2. Run `npm install -d` to install the node dependencies.
3. Run `./fetch-libs.sh` to fetch the third party client-side JS libraries.
4. Run `grunt` to compile and package up the application.
5. ???
6. PROFIT!


### Circumvent the Same Origin Policy with Nginx

The **same origin policy** prevents your document loaded from one origin from getting stuff from a different origin.
This means that you can't access the server from the client because they are not from the same origin. To bypass this,
you can use Nginx.

#### Nginx Installation and Configuration

##### OSX

0. Install [Homebrew](http://mxcl.github.com/homebrew/)
1. Install Nginx: `brew install nginx`
2. Copy the Nginx config file: `cp ops/nginx.conf /usr/local/etc/nginx/nginx.conf`
3. Start Nginx: `nginx`
3. Just in case, reload the Nginx config: `nginx -s reload`


## Building the app

### Website

This builds the **website** version of the client. It is the default grunt task.
If you want to build it manually, run `grunt build:website`.

### Phonegap

This builds the **phonegap** version of the client. The reason it is a separate build
is that the phonegap calls are added in during compilation.

To build this version, run `grunt build:phonegap`.


## Running the client

To run the application, use the `grunt run` command. This will build the app and open up an http
server on `port 8000`. The app will be rebuilt automatically if you change a source file.

By default, this task runs the **website** build. You can specify which build you want by adding a subtask.

- For the **phonegap** build, run `grunt run:phonegap`.
- For the **website** build, run `grunt run:website` or simply `grunt run`.


## Configuration

### Grunt

Located in: `/config/grunt`

This is where you set up the **compile-time** configuration.


### App

Located in: `/config/app`

This is where you set up the **run-time** configuration. It is injected into the `App` object as the
`config` property.
