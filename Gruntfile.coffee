# # Gruntfile
# This is the project Gruntfile. Here's the most important information that
# you'll need to know:
#
# ## During Development
# Using Grunt, you can automagically compile the project whenever source files
# change. Each type of source file type is watched separately, so only
# the necessary files are re-compiled, moved, etc. To enable this during
# development, just run `grunt watch`.
#
# ## Building the Project
# To compiled, test, and build the documentation for the entire project, simply
# run `grunt build`.
#
# ## Other Tasks
# Other Grunt tasks are documented below in the configuration object, and
# custom tasks are registered to simply things. Skip to the
# [Custom Grunt Tasks](#custom-grunt-tasks).

module.exports = (grunt) ->

  # ## Grunt Config
  # This is the configuration object we will pass to grunt.initConfig().
  config =

    # ### pkg
    # Read-in the package.json file for later use.
    pkg: (grunt.file.readJSON('package.json'))


    # ### coffeelint
    # Runs CoffeeLint, which and ensures that CoffeeScript files abide by the
    # style rules specified in the `coffeelint.json` configuration file. The
    # subtask `:dist` will only check distribution files and `:test` will only
    # check *test* CoffeeScript files.
    coffeelint:
      dist: ['assets/**/*.coffee']
      options:
        configFile: 'coffeelint.json'


    # ### coffee
    # Compiles all CoffeeScript *source* and *test* files. This task has two
    # subtasks. First, `:dist`, compiles CoffeeScript *source* files intended
    # for distribution to the `tmp/dist/` directory, where Browserify will grab
    # the compiled Javascript and process it into a single build file. The
    # second, `:test`, compiles the *test* files to Javascript in the
    # `tmp/test/` directory. In both cases, the directory original directory
    # structures are maintained.
    coffee:
      dist:
        expand: true,
        flatten: false,
        cwd: 'assets/coffee',
        src: ['./**/*.coffee'],
        dest: 'assets/js',
        ext: '.js'


    # ### sass
    # Compiles SASS source files into CSS, searching the `lib` directory as its
    # library path.
    sass:
      dist:
        options:
          loadPath: 'lib/'
        files:
          'assets/css/styles.css': 'assets/sass/styles.sass'


    # ### watch
    # This task watches for file modifications, then re-compiles or re-processes
    # the files accordingly. Having the individual subtasks for each file type
    # speeds-up compilation time while working. It's probably best just to use
    # `grunt watch` when working instead of using an individual subtask.
    watch:

      # #### :coffee
      # Watches for CoffeeScript file changes and re-compiles when a change
      # occurs. This subtask will also use Browserify to create the single
      # build file.
      coffee:
        files: ['assets/**/*.coffee'],
        tasks: ['compile:coffee']

      # #### :sass
      # Watches SASS files for changes and re-compiles to CSS.
      sass:
        files: ['assets/**/*.sass'],
        tasks: ['compile:sass']


  # Initiate Grunt with the above configuration.
  grunt.initConfig(config)

  # Load all Grunt NPM tasks.
  for pkg of config.pkg.devDependencies
    if /grunt\-/.test pkg
      grunt.loadNpmTasks pkg


  # ## Custom Grunt Tasks

  # ### compile
  # Compiles all output for distribution.
  grunt.registerTask('compile', [
    'compile:sass',
    'compile:coffee'])

  # ### compile:coffee
  # Compiles CoffeeScript files to the temporary directory.
  grunt.registerTask('compile:coffee', [
    'coffeelint',
    'coffee'])

  # ### compile:sass
  # Compiles SASS to CSS.
  grunt.registerTask('compile:sass', ['sass'])
