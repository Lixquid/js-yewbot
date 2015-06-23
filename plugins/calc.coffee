## Dependencies ################################################################

coffeeScript = require( "coffee-script" )

## Plugin ######################################################################

module.exports = ( bot ) ->

	bot.respond /^(?:calc|eval|what'?s)(.+)/i, ( from, match ) ->
		# HACK: Find out a better way to sandbox user code
		for i in [ "loop", "eval", "while", "for" ]
			if match[1].indexOf( i ) != -1
				return

		try
			bot.say( "#{from}: #{coffeeScript.eval( match[1] )}" )
		catch
			bot.say( "#{from}: Is the answer 'Low Battery'?" )
