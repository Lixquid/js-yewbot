module.exports = ( bot ) ->

	bot.respond /^ping$/i, ( from ) ->
		bot.say( "#{from}: Pong!" )
