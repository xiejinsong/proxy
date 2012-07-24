http = require('http')
url = require('url')
util = require('util')

BufferHelper = require('./bufferhelper')
OptionsModules = require('./optionsmodules')
ResModules = require('./resmodules')

class ProxyClient 
	constructor: (@config) ->
		
	forward: (req, res, callback) ->
		@start_date = new Date()

		data = ""
		req.on 'data', (chunk) ->
			data += chunk

		req.on 'end', () ->
			if req.method.match(/.*(POST|OPTIONS).*/)? then p_req.end(data) else p_req.end()				

		@options_modules = new OptionsModules(@config)
		@res_modules = new ResModules(@config)

		options = @parse req, (options) =>
			@options_modules.pipeAll(options)

		p_req = http.request options, (p_res) =>
			bfh = new BufferHelper()

			p_res.on 'data', (chunk) ->		
				bfh.concat(chunk)

			p_res.on 'end', () =>
				@end_date = new Date()
				buffer = bfh.toBuffer()

				@res_modules.pipeAll options, p_res, buffer, res, (statusCode, headers) ->
					res.writeHead(statusCode, headers)

				callback(@start_date, @end_date, options)

		p_req.on 'req-timeout', () ->
			if p_req? then p_req.abort()

		p_req.on 'error', () ->
			clearTimeout(setTimeout(p_req.emit('req-timeout'), 5000))				
	
	parse: (req, callback, options = {}) ->
		uri = url.parse(req.url)

		options.host = uri.host
		options.hostname = uri.hostname
		options.path = uri.path || '/'
		options.port = uri.port || 80
		options.search = uri.search
		options.method = req.method
		options.headers = req.headers
		options.href = uri.href

		headers = options.headers

		host = options.host
		port = @config.port

		if headers['X-Forwarded-For'] 
			headers['X-Forwarded-For'] = headers['X-Forwarded-For'] + ', ' + req.connection.remoteAddress
		else
			headers['X-Forwarded-For'] = req.connection.remoteAddress

		if headers['X-Forwarded-Proto']
			headers['X-Forwarded-Proto'] = headers['X-Forwarded-Proto'] + ', http'
		else
			headers['X-Forwarded-Proto'] = 'http'		

		if headers['X-Forwarded-Host']
			headers['X-Forwarded-Host'] = headers['X-Forwarded-Host'] + ', ' + host 
		else
			headers['X-Forwarded-Host'] = host
	
		if headers['X-Forwarded-Port']
			headers['X-Forwarded-Port'] = headers['X-Forwarded-Port'] + ', ' + port 
		else
			headers['X-Forwarded-Port'] = port		

		callback(options)
		return options

module.exports = ProxyClient