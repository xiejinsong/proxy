zlib = require('zlib')
util = require('util')
Iconv = require('iconv').Iconv

class ZlibUtil
	constructor: () ->
		@gbk_to_utf8 = new Iconv('GBK//TRANSLIT//IGNORE','UTF-8//TRANSLIT//IGNORE')
		@utf8_to_gbk = new Iconv('UTF-8//TRANSLIT//IGNORE','GBK//TRANSLIT//IGNORE')

	compress_type: (content_encoding) ->
		# Compress data using gzip.
		gzip = 'gzip'

		# Compress data using deflate
		deflate = 'deflate'		

		# Compress data using deflate, and do not append a zlib header
		deflateRaw = 'deflateRaw'

		if content_encoding.match(/.*(gzip).*/)?
			return gzip
		else if content_encoding.match(/.*(deflate).*/)?
			return deflate
		else if content_encoding.match(/.*(deflateRaw).*/)?	
			return deflateRaw
		else 
			return null

	compress: (content_type, content_encoding, str, callback) ->
		if content_type.match(/.*(gbk|GBK).*/)?
			buf = @utf8_to_gbk.convert(str)
		else 
			buf = new Buffer(str)

		type = @compress_type(content_encoding)

		if type?
			zlib["#{type}"] buf, (err, cbuf) ->
				callback(cbuf)
		else
			callback(buf)

	decompress_type: (content_encoding) ->
		# Decompress a gzip stream.
		gunzip = 'gunzip'

		# Decompress a deflate stream
		inflate = 'inflate'

		# Decompress a raw deflate stream
		inflateRaw = 'inflateRaw'		

		if content_encoding.match(/.*(gzip).*/)?
			return gunzip
		else if content_encoding.match(/.*(deflate).*/)?
			return inflate
		else if content_encoding.match(/.*(deflateRaw).*/)?	
			return inflateRaw
		else 
			return null

	decompress: (content_type, content_encoding, buffer, callback) ->
		type = @decompress_type(content_encoding)

		zlib[type] buffer, (err, decbuf) ->
			if content_type.match(/.*(gbk|GBK).*/)?
				str = @gbk_to_utf8.convert(decbuf).toString()
			else
				str = decbuf.toString()
			callback(str)
			
module.exports = new ZlibUtil()