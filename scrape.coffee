# Copyright Ajay Jain 2013

cheerio = require('cheerio')
http = require('http')
fs = require('fs')

themes =
	'politics': 6
	'culture': 3
	'health': 3
	'society': 3
	'economy': 4
	'sport': 1
	'education': 3
	'free-speech-debate': 2
	'religion': 2
	'philosophy': 2
	'science': 2
	'environment': 2
	'law': 4
	'international': 6

titleRe = new RegExp("<title>(.*?)</title>")

# queue = []

execCall = (theme) ->
	if not fs.existsSync theme
		fs.mkdirSync theme

	for page in [0...themes[theme]]
		url = "http://idebate.org/debatabase/themes/#{theme}?page=#{page}"

		console.log "URL: " + url

		http.get url, (listRes) ->
			if listRes.statusCode is 200
				listBody = ''
				listRes.on 'data', (chunk) ->
					listBody += chunk

				listRes.on 'end', ->
					console.log "Loaded list"

					$ = cheerio.load listBody
					$('.views-field-title a').each (index) ->
						pageHref = 'http://idebate.org' + $(this).attr('href')
						# console.log href
						pageBody = ''
						pageReq = http.get pageHref, (pageRes) ->
							pageRes.on 'data', (pageChunk) ->
								pageChunk = pageChunk.toString()
								canIndex = pageChunk.indexOf 'rel="canonical"'
								if canIndex > -1
									startIndex = canIndex + 46
									endIndex = pageChunk.indexOf '" />', startIndex
									id = pageChunk.substring startIndex, endIndex
									printHref = "http://idebate.org/print/" + id

									console.log "Got href from page " + printHref

									# pageReq.connection.destroy()

									printReq = http.get printHref, (printRes) ->
										printBody = ''
										printRes.on 'data', (printChunk) ->
											printBody += printChunk
										printRes.on 'end', ->
											printString = printBody.toString()
											title = printString.match titleRe
											title = title[1]
											console.log "Got print " + title
											# console.log printString
											# console.log()
											console.log theme
											fs.writeFile "./digest/#{theme}/#{title}.html", printString, (err) ->
												if err then console.log err.message
												# cb()

for theme of themes
	execCall(theme)