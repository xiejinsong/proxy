jsonmock = () ->
	jsonmock = []

	mtop_replace = {}
	mtop_replace.path = "api.m.taobao.com/rest/api3.do"
	mtop_replace.search = "api=com.taobao.client.sys.login"
	mtop_replace.file = "./json/api3.do"

	mtop_replace1 = {}
	mtop_replace1.path = "wapa.taobao.com/indexHeaderAjax.htm"
	mtop_replace1.search = ""
	mtop_replace1.file = "./json/indexHeaderAjax.htm"

	jsonmock.push(mtop_replace)
	jsonmock.push(mtop_replace1)	

	return jsonmock

module.exports = jsonmock()