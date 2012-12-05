

makeConfigResolver = (baseDir, configNameTemplate) ->

    # Try to import a config, return nothing if it doesn't exist.
    getConfig = (path) ->
        try return (require path)

    getFullConfigName = (grunt, configName) ->
        grunt.utils._.template configNameTemplate, {name:configName}

    # Get the contents of the list of config names, and don't include the
    # ones that cannot be found.
    getConfigs = (grunt, configNames) ->

        for configName in configNames

            fullConfigName = getFullConfigName grunt, configName
            path   = "#{baseDir}/#{fullConfigName}"
            config = getConfig path

            # The config doesn't exist, so we're informing the user.
            if not config
                grunt.log.error "Could not find config '#{fullConfigName}' in '#{baseDir}'."
                continue

            config

    # Grab the configs specified and merge them.
    (grunt, configNames) ->
        return grunt.utils._.extend {}, (getConfigs grunt, configNames)...


resolveAppConfig   = makeConfigResolver "./config/app",   "app-config-<%= name %>"
resolveGruntConfig = makeConfigResolver "./config/grunt", "grunt-config-<%= name %>"


registerGruntTask = (grunt, task, subtasks) ->
    grunt.registerTask task, subtasks.join '\n'


loadTask = (grunt, baseDir, task) ->
    (require "#{baseDir}/#{task}").call grunt, grunt


module.exports = {
    resolveAppConfig
    resolveGruntConfig
    registerGruntTask
    loadTask
}