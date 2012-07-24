jsonmock = () ->
	jsonmock = []

	mtop_replace = {}
	mtop_replace.path = "api.m.taobao.com/rest/api3.do"
	mtop_replace.search = "api=com.taobao.client.sys.login"
	mtop_replace.file = "./json/api3.do"

	jsonmock.push(mtop_replace)

	return jsonmock

module.exports = jsonmock()