
# Virtual Plaza Client


## Main Dependencies

name          | url
--------------|-----------------------------------
Node.js + NPM | http://nodejs.org/
Compass       | http://compass-style.org/
CoffeeScript  | http://coffeescript.org/
Grunt         | https://github.com/gruntjs/grunt


### Installation

1. Install **Node.js** and **Compass**.
2. Run `npm install grunt -g` to install **Grunt**.
4. Run `npm install -d` to install the dependencies.
5. Run `./fetch-libs.sh` to fetch the third party client-side JS libraries.
6. Run `grunt` to compile and package up the application.
7. ???
8. PROFIT!


## Running the client

To run the application, use the `grunt run` command. This will open up a
server listening on `port 8000`, and will rebuild the app when you change
a source file. This runs the `website` build.


## Configuration

### Grunt

### App



## Building the app

### Website

The default grunt task builds the website version of the client.

If you want to build it manually, run `grunt build:website`.

### Phonegap

This builds the phonegap version of the client. The reason it is a separate build
is that the phonegap calls are added in during compilation.

To build this version, run `grunt build:phonegap`.