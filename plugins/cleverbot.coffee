## Dependencies ################################################################

cleverbot = new ( require "cleverbot-node" )

## Plugin ######################################################################

muted = false
busy = false
excited = false

module.exports = ( bot ) ->

	# FIXME: Cleverbot module needs to be fixed first
	return

	bot.respond /^be quiet/i, ->
		muted = true
	bot.respond /^(don'?t be|stop being) quiet/i, ->
		muted = false

	bot.respond /^talk more/i, ( from ) ->
		if excited
			bot.say( "#{from}: help i can't even" )
		else
			bot.say( "#{from}: aaa im too excited" )
		excited = true

	bot.respond /^talk less/i, ( from ) ->
		if excited
			bot.say( "#{from}: awww ok" )
		else
			bot.say( "#{from}: wow rude im already quiet wtf do u want" )
		excited = false

	bot.listen ( from, msg ) ->

		# Don't reply if busy or muted
		if busy or muted
			return

		# Make sure we don't blabber too much
		if excited
			if Math.random() < 0
				return
		else
			if Math.random() < 0.99
				return

		# Talk random crap
		busy = true
		cleverbot.write( msg.replace( /\bYewBot\b/ig, "Cleverbot" ), ( res ) ->
			busy = false

			if not res or not res.message
				return

			bot.say( res.message.replace( /\bCleverbot\b/ig, "YewBot" ) )
		)
