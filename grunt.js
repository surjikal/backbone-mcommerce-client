
module.exports = function(grunt) {

  grunt.loadTasks( "tasks" );

  grunt.loadNpmTasks( "grunt-coffee" );
  grunt.loadNpmTasks( "grunt-compass" );
  grunt.loadNpmTasks( "grunt-handlebars" );
  grunt.loadNpmTasks( "grunt-contrib-copy" );
  grunt.loadNpmTasks( "grunt-contrib-clean" );

  grunt.initConfig({
  
    clean: {
      build: "build"
    },

    // Compile CoffeeScript files to JavaScript
    // https://github.com/avalade/grunt-coffee
    coffee: {
      app: {
        src:  'src/scripts/app/**/*.coffee',
        dest: 'build/assets/js/app',
        options: {
          preserve_dirs: true,
          base_path: 'src/scripts/app'
        }
      },
      'handlebars-custom-helpers': {
        src: 'src/jade/templates/handlebars-custom-helpers.coffee',
        dest: 'build/assets/js/handlebars-custom-helpers.js'
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
        dest: 'build/assets/templates/handlebars',
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
        src:  'build/assets/templates/handlebars',
        dest: 'build/assets/js/app/templates.js'
      }
    },

    copy: {
      jslibs: {
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
        files: ["grunt.js", "src/**/*"],
        tasks: "default"
      }
    }

  });
  
  grunt.registerTask('default', 'clean coffee jade handlebars compass copy');
  grunt.registerTask('run',     'default server watch');
};
