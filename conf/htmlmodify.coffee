htmlmodify = () ->
	htmlmodify = []

	html_replace = {}
	html_replace.path = "http://s.wapa.taobao.com/search.htm"
	#html_replace.search = "api=com.taobao.client.sys.login"
	html_replace.content = "http://a.tbcdn.cn/mw/app/searchlist/h5/js/searchlist.js"
	html_replace.replace = "http://10.13.123.70/app/searchlist/h5/js/searchlist.js"

	htmlmodify.push(html_replace)

	return htmlmodify

module.exports = htmlmodify()