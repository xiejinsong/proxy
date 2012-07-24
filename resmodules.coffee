util = require('util')
fs = require('fs')
querystring = require('querystring')

QueryStringUtil = require('./querystringutil')
ZlibUtil = require('./zlibutil')

class ResModules 
	constructor: (@config) ->
		@use = @config.res_modules.use || false 
		@modules = []

		if @use
			@modules.push(new HtmlModify(@config))
			@modules.push(new JsonSave(@config))
			@modules.push(new JsonMock(@config))

		@modules.push(new Othons(@config))

	pipeAll: (options, p_res, buffer, res, callback) ->
		if @modules[0]?
			return if @modules[0].pipe(options, p_res, buffer, res, callback)
			@modules.splice(0, 1)
			@pipeAll(options, p_res, buffer, res, callback)
		else
			return

class Othons
	constructor: (@config) ->

	pipe: (options, p_res, buffer, res, callback) ->
		res.writeHead(p_res.statusCode, p_res.headers)
		
		if buffer.length? 
			res.write(buffer)
			res.end()
			return true
		else
			res.end()
			return true

class Mock
	constructor: () ->
		
	init: (p_res) ->
		@headers = p_res.headers
		@statusCode = p_res.statusCode
		@content_encoding = @headers["content-encoding"] || ""
		@content_type = @headers["content-type"] || ""

class JsonMock extends Mock
	constructor: (@config) ->
		@rules = require(@config.res_modules.jsonmock || './conf/jsonmock') || []

	pipe: (options, p_res, buffer, res, callback) =>
		@init(p_res)

		if !(@statusCode == 200) || !@content_type? || !@content_type.match(/.*(application\/json).*/)
			return false

		for rule in @rules
			if options.href.match(".*(#{rule['path']}).*") && QueryStringUtil.queryStringDiff(options.search, rule['search'])
				str = fs.readFileSync("#{rule['file']}")
				buf = new Buffer(str)
				p_res.headers['content-length'] = buf.length
				res.writeHead(p_res.statusCode, p_res.headers)
				res.write(buf)
				res.end()
				return true
		return false

class JsonSave extends Mock
	constructor: (@config) ->
		@rules = require(@config.res_modules.jsonmock || './conf/jsonsave') || []		

	pipe: (options, p_res, buffer, res, callback) =>
		@init(p_res)

		if !(@statusCode == 200) || !@content_type? || !@content_type.match(/.*(application\/json).*/)
			return false

		for rule in @rules
			if options.href.match(".*(#{rule['path']}).*") && QueryStringUtil.queryStringDiff(options.search, rule['search'])
				fs.writeFile "#{rule['path']}_#{rule['search']}_#{(new data()).getTime()}", buffer, (err) ->

				return true
		return false
							
class HtmlModify extends Mock
	constructor: (@config) ->
		@rules = require(@config.res_modules.htmlmodify || './conf/htmlmodify') || []

	pipe: (options, p_res, buffer, res, callback) ->
		@init(p_res)

		if !(@statusCode == 200) || !@content_type? || !@content_type.match(/.*(text\/html).*/)
			return false	

		for rule in @rules
			if options.href.match(".*(#{rule['path']}).*") && QueryStringUtil.queryStringDiff(options.search, rule['search'])			
				ZlibUtil.decompress @content_type, @content_encoding, buffer, (str) =>
					str = str.replace("#{rule['content']}", "#{rule['replace']}")
					ZlibUtil.compress @content_type, @content_encoding, str, (cbuf) =>
						res.writeHead(p_res.statusCode, p_res.headers)
						res.write(cbuf)
						res.end()
				return true		
		return false

module.exports = ResModules