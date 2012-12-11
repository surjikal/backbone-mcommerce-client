
utils = require './grunt-utils'

NPM_TASKS = [
    'grunt-coffee'
    'grunt-compass'
    'grunt-contrib-copy'
    'grunt-contrib-clean'
    'grunt-handlebars'
    'grunt-jade'
]

TASKS = [
    'grunt-connect'
    'grunt-config-context'
]


module.exports = (grunt) ->

    NPM_TASKS.forEach (task) ->
        grunt.loadNpmTasks task

    TASKS.forEach (task) ->
        utils.loadTask grunt, './grunt-tasks', task

    # Should be called init tasks... it would make more sense.
    grunt.initConfig

        # Defines the set of configs to be used.
        configContext:
            website:  ['website',  'local-website']
            phonegap: ['phonegap', 'local-phonegap']

        #config: gets created by the configContext task

        # Remove some directories
        clean:
            build_directory: '<%= config.build_directory %>'
            tmp_directory:   '<%= config.tmp_directory   %>'

        # Compile the coffee files
        coffee:
            app:
                src:  'src/scripts/app/**/*.coffee'
                dest: '<%= config.build_directory %>/assets/js/app'
                options:
                    base_path: 'src/scripts/app'
                    preserve_dirs: true
                    bare: false

        # Compile the jade files
        jade:

            # Compiles the index file of the website version, adds the app config to locals
            website_index:
                src:  'src/jade/index.jade'
                dest: '<%= config.build_directory %>'
                options:
                    client: false
                    pretty: true
                    compileDebug: true
                    locals: ->
                        context = grunt.config.get 'configContext.website'
                        config: (utils.resolveAppConfig grunt, context)

            # Compiles the index file of the phonegap version, adds the app config to locals
            phonegap_index:
                src:  'src/jade/index.jade'
                dest: '<%= config.build_directory %>'
                options:
                    client: false
                    pretty: true
                    compileDebug: true
                    locals: ->
                        context = grunt.config.get 'configContext.phonegap'
                        config: (utils.resolveAppConfig grunt, context)
                        phonegap: true

            # Compiles the handlebars templates to html
            handlebars:
                src:  'src/jade/templates/**/*.jade'
                dest: 'tmp/templates/handlebars'
                options:
                    client: false
                    extension: ''


        # Precompile the handlebars templates
        handlebars:
            js:
                src:  'tmp/templates/handlebars'
                dest: '<%= config.build_directory %>/assets/js/app/templates.js'


        # Copy some assets...
        copy:
            # Copy the libraries fetched by the `fetch-libs.sh` script
            fetched_js_libs:
                files: '<%= config.build_directory %>/assets/js/libs/':  '.fetched-libs/**'

            # Copy the libraries that were saved in the app's `libs` dir
            js_libs:
                files: '<%= config.build_directory %>/assets/js/libs/':  'src/scripts/libs/**'

            # Copy the images
            images:
                files: '<%= config.build_directory %>/assets/images/':   'src/images/**'


        # CSS Compass compilation
        compass:
            dev:
                src: 'src/styles'
                dest: '<%= config.build_directory %>/assets/css'
                images: 'src/images'
                fonts: 'src/fonts'
                relativeassets: true
                linecomments: true


        # Create HTTP Server on a directory
        connect:
            base: ->
                grunt.config.get 'config.build_directory'

            middleware: (grunt, connect, base) -> [

                # Always serve index file, unless it's an ajax or asset request
                # This allows the backbone router to handle the request.
                (request, response, next) ->
                    isAjaxRequest  = 'x-requested-with' in request.headers
                    isAssetRequest = /\/assets\/.*/.test request.url

                    request.url = '/' unless isAjaxRequest or isAssetRequest
                    next()

                # Serve static files.
                connect.static base
                # Make empty directories browsable. (overkill?)
                connect.directory base
            ]

        # Rebuild everything when something changes
        watch:
            website:
                files: [
                    'grunt.coffee'
                    'grunt.js'
                    'src/**/*'
                    'config/**/*.coffee'
                ]
                tasks: 'build:website'
            phonegap:
                files: [
                    'grunt.coffee'
                    'grunt.js'
                    'src/**/*'
                    'config/**/*.coffee'
                ]
                tasks: 'build:phonegap'


    utils.registerGruntTask grunt, 'build', [
        'build:phonegap'
        'build:website'
    ]

    utils.registerGruntTask grunt, 'build:phonegap', [
        'configContext:phonegap'
        'clean:build_directory'
        'coffee'
        'jade:phonegap_index'
        'jade:handlebars'
        'handlebars'
        'compass'
        'copy'
        'clean:tmp_directory'
    ]

    utils.registerGruntTask grunt, 'build:website', [
        'configContext:website'
        'clean:build_directory'
        'coffee'
        'jade:website_index'
        'jade:handlebars'
        'handlebars'
        'compass'
        'copy'
        'clean:tmp_directory'
    ]

    utils.registerGruntTask grunt, 'default', [
        'build:website'
    ]


    utils.registerGruntTask grunt, 'run', [
        'default'
        'connect'
        'watch'
    ]

    utils.registerGruntTask grunt, 'run:website', [
        'build:website'
        'connect'
        'watch:website'
    ]

    utils.registerGruntTask grunt, 'run:phonegap', [
        'build:phonegap'
        'watch:phonegap'
    ]



    # TODO: It would be cool if the `fetch-libs.sh` script was ported to a grunt task.
