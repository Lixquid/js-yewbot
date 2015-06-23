respond_regex = ///
	^ roll \s*
	(?: a \s+ | ( \d+ ) \s* )?	# Number of dice
	(?: d ( \d+ ) s? | die | dice )?	# Type of dice
///i

module.exports = ( bot ) ->

	bot.respond respond_regex, ( from, match ) ->
		num = parseInt( match[1] ? 1 )
		max = parseInt( match[2] ? 6 )

		results = []
		for [1..num]
			results.push Math.floor( Math.random() * max + 1 )#

		output = from + " rolled "
		if max == 6
			if num == 1
				output += "a die: "
			else
				output += "#{num} dice: "
		else
			if num == 1
				output += "a d#{max}: "
			else
				output += "#{num} d#{max}s: "

		output += results.join( ', ' )
		bot.say( output )
