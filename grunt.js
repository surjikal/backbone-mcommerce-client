
require('coffee-script');


function resolveAppConfig(grunt) {

  function getAppConfig(path) {
    try {
      return require('./config/'+path);
    } catch(e) {
      grunt.log.writeln("\nCould not find config '" + path + "'\n");
    }
  }

  var defaultConfig = getAppConfig('default') || {};
  var localConfig   = getAppConfig('local')   || {};

  return grunt.utils._.extend(defaultConfig, localConfig);
}


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
          client: false,
          pretty: true,
          locals: function() {
            var config = resolveAppConfig(grunt);
            grunt.log.writeln('Resolved app config:');
            grunt.log.writeln(JSON.stringify(config, null, 2));
            return {config:config};
          }
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
      savedclientlibs: {
        files: {
          "build/assets/js/libs/": "src/scripts/libs/**"
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
        files: [
          "grunt.js",
          "src/**/*",
          "config/default.coffee",
          "config/local.coffee"
        ],
        tasks: "default"
      }
    }

  });

  grunt.registerTask('default', 'clean:build coffee jade handlebars compass copy clean:tmp');
  grunt.registerTask('run',     'default server watch');
  // TODO: It would be cool if the `fetch-libs.sh` script was ported to a grunt task.
};
