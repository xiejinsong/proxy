config = () ->
	config = {}
	config.port = 8888

	config.options_modules = {}
	config.options_modules.use = false
	config.options_modules.urlreplace = "./conf/urlreplace"
	
	config.res_modules = {}
	config.res_modules.use = true
	config.res_modules.jsonmock = "./conf/jsonmock"
	config.res_modules.htmlmodify = "./conf/htmlmodify"

	return config

module.exports = config()
