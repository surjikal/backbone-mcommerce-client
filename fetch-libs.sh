#!/bin/sh
# Utility script to fetch your client-side libraries.


LIBS_DIR="./src/scripts/libs"

COLOR_RED="\033[0;31m"
COLOR_PURPLE="\033[0;35m"
COLOR_BRIGHT_PURPLE="\033[1;35m"
COLOR_GREEN="\033[0;32m"
COLOR_RESET="\033[0m"


function fetch {
    filename=$1
    url=$2
    filepath="$LIBS_DIR/$filename"

    printf "$COLOR_PURPLE+ $COLOR_BRIGHT_PURPLE%-26s$COLOR_RESET " $filename

    # Create the output directory if it doesn't exist.
    [ ! -d $LIBS_DIR ] && mkdir -p $LIBS_DIR

    # Don't fetch the script if it is there already.
    if [ -f "$filepath" ]; then
        printf "%s\n" 'skip'
    else
        wget --timeout 5 --tries 1 -O "$filepath" $url 2> /dev/null

        if [ $? -ne 0 ]; then
            # Could not fetch the script...
            printf "$COLOR_RED%s$COLOR_RESET\n" '✗'
            rm "$filepath" 2> /dev/null
        else
            # Fetch was successful
            printf "$COLOR_GREEN%s$COLOR_RESET\n" '✓'
        fi
    fi
}

function remove_existing_libs {
    rm $LIBS_DIR/*.js 2> /dev/null
}

# ./fetch-libs.sh -c
[[ $1 = "-c" || $1 = "--clean" ]] && remove_existing_libs


fetch 'zepto.js'                    http://zeptojs.com/zepto.js
fetch 'jquery.js'                  https://cdnjs.cloudflare.com/ajax/libs/jquery/1.8.2/jquery.js
fetch 'jquery.cookie.js'           https://raw.github.com/carhartl/jquery-cookie/master/jquery.cookie.js
fetch 'jquery.base64.js'           https://raw.github.com/carlo/jquery-base64/master/jquery.base64.js
fetch 'lodash.js'                  https://raw.github.com/bestiejs/lodash/v0.9.0/lodash.js
fetch 'underscore.deferred.js'     https://raw.github.com/wookiehangover/underscore.deferred/master/underscore.deferred.js
fetch 'backbone.js'                 http://backbonejs.org/backbone.js
fetch 'backbone.layoutmanager.js'  https://raw.github.com/tbranyen/backbone.layoutmanager/master/backbone.layoutmanager.js
fetch 'backbone.statemachine.js'   https://raw.github.com/sebpiq/backbone.statemachine/master/backbone.statemachine.js
fetch 'backbone.relational.js'     https://raw.github.com/PaulUithol/Backbone-relational/master/backbone-relational.js
fetch 'backbone.queryparams.js'    https://raw.github.com/jhudson8/backbone-query-parameters/master/backbone.queryparams.js
fetch 'backbone.basicauth.js'      https://raw.github.com/fiznool/backbone.basicauth/master/backbone.basicauth.js
fetch 'backbone.localstorage.js'   https://raw.github.com/jeromegn/Backbone.localStorage/master/backbone.localStorage.js
fetch 'handlebars.runtime.js'       http://cloud.github.com/downloads/wycats/handlebars.js/handlebars.runtime-1.0.rc.1.js
