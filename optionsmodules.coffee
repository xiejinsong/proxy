QueryStringUtil = require('./querystringutil')

class OptionsModules
	constructor: (@config) ->
		@use = @config.options_modules.use || false 
		@modules = []
		@modules.push(new UrlReplace(@config))

	pipeAll: (options) ->
		if @use && @modules[0]?
			return if @modules[0].pipe(options)
			@modules.splice(0, 1)
			@pipeAll(options)
		else
			return

class UrlReplace
	constructor: (@config) ->
		@rules = require(@config.options_modules.urlreplace || './conf/urlreplace') || []

	pipe: (options) ->
		for rule in @rules
			if options.href.match(".*(#{rule['path']}).*") && QueryStringUtil.queryStringDiff(options.search, rule['search'])
				options.host = options.hostname = rule['replace']
				return true
		return false

module.exports = OptionsModules 