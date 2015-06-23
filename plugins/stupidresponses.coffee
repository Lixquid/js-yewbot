muted = false

module.exports = ( bot ) ->

	bot.respond /^be quiet/i, ( from ) ->
		if muted
			bot.say( "#{from}: Banter already at minimum levels" )
		else
			bot.say( "#{from}: Activating Banter suppression" )
		muted = true

	bot.respond /^(don'?t be|stop being) quiet/i, ->
		if muted
			bot.say( "#{from}: Banter spooling up to maximum emission" )
		else
			bot.say( "#{from}: Banter output already at maximum allowance" )
		muted = false

	bot.listen ( from, msg ) ->

		if muted
			return

		if msg.match( /rabbit/i ) and Math.random() < 0.05
			bot.say( "*grunt*" )
			bot.say( "*stamp* *stamp* *stamp*" )

		if msg.match( /\b(thanks|ty)\s+(yew)?bot/i )
			bot.say( "You're welcome." )

		if msg.match( /quantum/i ) and Math.random() < 0.03
			bot.say( "winmail.dat?" )
