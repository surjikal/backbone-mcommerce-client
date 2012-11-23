
module.exports = function(grunt) {

  [ "grunt-jade"
  , "grunt-coffee"
  , "grunt-compass"
  , "grunt-handlebars"
  , "grunt-contrib-copy"
  , "grunt-contrib-clean"
  ].forEach(grunt.loadNpmTasks)

  grunt.initConfig({

    clean: {
      build: "build",
      tmp: "tmp"
    },

    // Compile CoffeeScript files to JavaScript
    // https://github.com/avalade/grunt-coffee
    coffee: {
      app: {
        src:  'src/scripts/app/**/*.coffee',
        dest: 'build/assets/js/app',
        options: {
          preserve_dirs: true,
          base_path: 'src/scripts/app',
          bare: false
        }
      }
    },

    jade: {

      index: {
        src:  'src/jade/index.jade',
        dest: 'build/',
        options: {
          client: false
        }
      },

      handlebars: {
        src:  'src/jade/templates/**/*.jade',
        dest: 'tmp/templates/handlebars',
        options: {
          client: false,
          extension: ''
        }
      }
    },

    lint: {
      files: [
        "build/config.js", "app/**/*.js"
      ]
    },

    handlebars: {
      js: {
        src:  'tmp/templates/handlebars',
        dest: 'build/assets/js/app/templates.js'
      }
    },

    copy: {
      clientlibs: {
        files: {
          "build/assets/js/libs/": "client_libs/**"
        }
      },
      csslibs: {
        files: {
          "build/assets/css/libs/": "src/styles/libs/**"
        }
      },
      images: {
        files: {
          "build/assets/images/": "src/images/**"
        }
      }
    },

    compass: {
      dev: {
        src: 'src/styles',
        dest: 'build/assets/css',
        linecomments: true,
        images: 'src/images',
        fonts: 'src/fonts',
        relativeassets: true
      }
    },

    server: {
      base: './build'
    },

    watch: {
      all: {
        files: ["grunt.js", "src/**/*"],
        tasks: "default"
      }
    }

  });

  grunt.registerTask('default', 'clean:build coffee jade handlebars compass copy clean:tmp');
  grunt.registerTask('run',     'default server watch');
  // TODO: It would be cool if the `fetch-libs.sh` script was ported to a grunt task.
};
