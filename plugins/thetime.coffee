regex = ///
	^
	( what'?s \s+ )?
	( the \s+ )?
	time
///i

module.exports = ( bot ) ->

	bot.respond regex, ( from ) ->
		bot.say "#{from}, it's #{new Date}"
