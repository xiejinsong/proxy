class BufferHelper
	constructor: () ->
		@buffers = []
		@size = 0
		@_status = 'changed'

	concat: (buffer) ->
		@_concat(arguments[i]) for i in [0...arguments.length]
		return @

	_concat: (buffer) ->
		@buffers.push buffer
		@size += buffer.length
		@_status = 'changed'
		return @

	empty: () ->
		@buffers = []
		@size = 0
		@_status = 'changed'

	_toBuffer: () ->
		data = null
		buffers = @buffers
		switch @buffers.length
			when 0 then data = new Buffer(0)
			when 1 then data = buffers[0]
			else
				data = new Buffer(@size)
				pos = 0
				for i in [0...buffers.length] 
					buffer = buffers[i]
					buffer.copy(data, pos)
					pos += buffer.length

		@_status = 'computed'
		@buffer = data
		return data

	toBuffer: () ->
		return if @_status == 'computed' then @buffer else @_toBuffer()

	toString: () ->
		return Buffer.prototype.toString.apply(@toBuffer(), arguments)

module.exports = BufferHelper