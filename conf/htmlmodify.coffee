htmlmodify = () ->
	htmlmodify = []

	html_replace = {}
	html_replace.path = "http://s.wapa.taobao.com/search.htm"
	#html_replace.search = "api=com.taobao.client.sys.login"
	html_replace.content = "http://a.tbcdn.cn/mw/app/searchlist/h5/js/searchlist.js"
	html_replace.replace = "http://10.13.123.70/app/searchlist/h5/js/searchlist.js"

	htmlmodify.push(html_replace)

	html_replace2 = {}
	html_replace2.path = "http://m.taobao.com"
	#html_replace.search = "api=com.taobao.client.sys.login"
	html_replace2.content = "http://a.tbcdn.cn/mw/app/index/h5/js/indexCache.js"
	html_replace2.replace = "http://10.13.123.68/app/index/h5/js/indexCache.js"

	htmlmodify.push(html_replace2)	

	js_replace = {}
	js_replace.path = "http://m.taobao.com"
	js_replace.content = "<body>"
	js_replace.replace = "<body><script src=\"http://localhost:8080/target/target-script-min.js#anonymous\"></script>"

	htmlmodify.push(js_replace)

	return htmlmodify

module.exports = htmlmodify()