#!/bin/sh
# Utility script to fetch your client-side libraries.

# Checking if 'wget' is installed.
command -v wget >/dev/null 2>&1 || { echo >&2 "This script needs 'wget' but it is not installed. Aborting."; exit 1; }


LIBS_DIR="./.fetched-libs"

COLOR_RED="\033[0;31m"
COLOR_PURPLE="\033[0;35m"
COLOR_BRIGHT_PURPLE="\033[1;35m"
COLOR_GREEN="\033[0;32m"
COLOR_RESET="\033[0m"


function fetch {
    filename=$1
    url=$2
    filepath="$LIBS_DIR/$filename"

    printf "$COLOR_BRIGHT_PURPLE%-26s$COLOR_RESET " $filename

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
    rm -rf $LIBS_DIR 2> /dev/null
    mkdir $LIBS_DIR
}


# ./fetch-libs.sh -c
[[ $1 = "-c" || $1 = "--clean" ]] && remove_existing_libs


fetch 'jquery.js'                  https://cdnjs.cloudflare.com/ajax/libs/jquery/1.8.2/jquery.js
fetch 'lodash.js'                  https://raw.github.com/bestiejs/lodash/v0.9.0/lodash.js
# fetch 'backbone.js'                 http://backbonejs.org/backbone.js
fetch 'backbone.layoutmanager.js'  https://raw.github.com/tbranyen/backbone.layoutmanager/master/backbone.layoutmanager.js
fetch 'backbone.statemachine.js'   https://raw.github.com/sebpiq/backbone.statemachine/master/backbone.statemachine.js
# fetch 'backbone.relational.js'     https://raw.github.com/philfreo/Backbone-relational/backbone-0.9.9/backbone-relational.js
fetch 'backbone.queryparams.js'    https://raw.github.com/jhudson8/backbone-query-parameters/master/backbone.queryparams.js
fetch 'backbone.basicauth.js'      https://raw.github.com/fiznool/backbone.basicauth/master/backbone.basicauth.js
fetch 'backbone.localstorage.js'   https://raw.github.com/jeromegn/Backbone.localStorage/master/backbone.localStorage.js
fetch 'handlebars.runtime.js'       http://cloud.github.com/downloads/wycats/handlebars.js/handlebars.runtime-1.0.rc.1.js
