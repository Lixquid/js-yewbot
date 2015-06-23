## Dependencies ################################################################

http = require "http"

## Plugin ######################################################################
getFromUD = ( url, callback ) ->

	http.get( url, ( res ) ->

		# Create JSON
		json = ""
		res.on "data", ( d ) -> json += d
		res.on "end", ->
			data = JSON.parse( json )

			# Parse
			if not data
				return

			callback( data.list[0] )

	)

module.exports = ( bot ) ->

	bot.respond /^define\W+random/i, ( from ) ->
		data = getFromUD(
			"http://api.urbandictionary.com/v0/random",
			( data ) ->
				bot.say( "
					#{from}:
					#{data.word}:
					#{data.definition} \n
					e.g.: #{data.example}
				")
		)

	bot.respond /^define\W+([\w\s]+)/i, ( from, match ) ->
		if match[1].toLowerCase() == "random"
			return
		data = getFromUD(
			"http://api.urbandictionary.com/v0/define?term=" + match[1],
			( data ) ->
				bot.say( "
					#{from}:
					#{data.word}:
					#{data.definition} \n
					e.g.: #{data.example}
				")
		)
