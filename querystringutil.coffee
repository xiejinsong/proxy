querystring = require('querystring')

class QueryStringUtil
	queryStringDiff: (search, diff_search) ->
		s = querystring.unescape(search || "")
		#diff_s = querystring.unescape(diff_search || "")
		diff_s = diff_search || ""

		return true if s == diff_s
		return false for ss in diff_s.split('&') when !s.match(".*(#{ss}).*")
		return true	

module.exports = new QueryStringUtil()