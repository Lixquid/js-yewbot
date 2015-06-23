## Dependencies ################################################################

http = require "http"

## Plugin ######################################################################

url = "http://api.urbandictionary.com/v0/define?term="

module.exports = ( bot ) ->

	bot.respond /^define\W+([\w\s]+)/i, ( from, match ) ->

		# Get from API
		http.get( url + match[1], ( res ) ->

			# Create JSON Object
			json = ""
			res.on "data", ( d ) -> json += d
			res.on "end", ->

				data = JSON.parse( json )

				# Parse
				if not data
					return

				data = data.list[0]

				bot.say( "#{from}:
					#{data.word}:
					#{data.definition}
					\n
					e.g.: #{data.example}" )
		)
