HttpProxy = require('./httpproxy')
util = require('util')

server = new HttpProxy()
server.listen 8888

process.on 'uncaughtException', (err) ->
	console.log('LAST ERROR: Caught exception: ' + err)
	util.log(err.stack)

console.log "server start...."