urlreplace = () ->
	urlreplace = []

	mtop_replace = {}
	mtop_replace.path = "api.m.taobao.com/rest/api3.do"
	mtop_replace.search = "api=com.taobao.client.sys.login"
	mtop_replace.replace = "api.waptest.taobao.com"

	urlreplace.push(mtop_replace)

	return urlreplace

module.exports = urlreplace()