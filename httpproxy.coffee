http = require('http')
util = require('util')
ProxyClient = new require('./proxyclient')

class HttpProxy
	constructor: (@config) ->
		@config = require('./conf/config.coffee') if !(@config?)
		@server = http.createServer()
		proxy_client = new ProxyClient(@config)
		@server.on 'request', (req, res) ->
			proxy_client.forward req, res, (start_date, end_date, options) ->
				util.log "#{end_date.getTime() - start_date.getTime()} #{options.href}"

	listen: (port) ->
		@server.listen port || config.port

module.exports = HttpProxy