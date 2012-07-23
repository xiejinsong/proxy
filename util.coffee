zlib = require('zlib')
util = require('util')
Iconv = require('iconv')

gbk_to_utf8 = new Iconv('GBK//TRANSLIT//IGNORE','UTF-8//TRANSLIT//IGNORE')
utf8_to_gbk = new Iconv('UTF-8//TRANSLIT//IGNORE','GBK//TRANSLIT//IGNORE')

class ZlibUtil
	gzip = (res, buf) ->
		zlib.gzip buf, (err, gzip) ->
			res.write(gzip)
			res.end()

	gunzip = (buffer, res, callback) ->
		zlib.gunzip buffer, (err, gunzip) ->
			str = gunzip.toString()
			buf = new Buffer(callback(str))
			
	gunzipGBK = (buffer, res, callback) ->
		zlib.gunzip buffer, (err, gunzip) ->
			str = gbk_to_utf8.convert(gunzip).toString()				
			buf = utf8_to_gbk.convert(callback(str))

	deflateRaw = (res, buf) ->
		zlib.deflateRaw buf, (err, deflateRaw) ->
			res.write(deflateRaw)
			res.end()			

	deflate = (buffer, res, callback) ->
		zlib.deflate buffer, (err, deflate) ->
			str = deflate.toString()
			buf = new Buffer(callback(str))

	deflateGBK = (buffer, res, callback) ->
		zlib.deflate buffer, (err, deflate) ->
			str = gbk_to_utf8.convert(deflate).toString()				
			buf = utf8_to_gbk.convert(callback(str))

module.exports = ZlibUtil