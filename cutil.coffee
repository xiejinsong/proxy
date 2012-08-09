logger = require('./loggerutil')

class CUtil 
	constructor: () ->

	delay: () ->
		parseInt(Math.random() * (1000 - 200 + 1) + 200)

	forward: (p_res, buffer, res, callback) ->
		delay_int = @delay()
		logger.debug "forward delay :" + delay_int
		setTimeout((() => @_forward(p_res, buffer, res)), delay_int)

	_forward: (p_res, buffer, res) ->
		res.writeHead(p_res.statusCode, p_res.headers)
		
		if buffer.length? 
			res.write(buffer)
			res.end()
		else
			res.end()

module.exports = new CUtil()