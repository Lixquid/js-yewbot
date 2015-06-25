module.exports = ( bot ) ->

	spec_limit = 5
	gen_limit = 25

	last_said_spec = {}
	last_said_general = []

	sed_regex = /^s\/([^/]+)\/([^/]+)\/([i])?$/

	# If we hear that magical sed command..
	bot.listen sed_regex, ( from, match ) ->
		try
			target = new RegExp( match[1], "g" + ( match[3] ? "" ) )
		catch ex
			return bot.say( "#{from}: #{ex.message}" )

		# First, scan personal messages
		for msg in last_said_spec[ from ]
			if msg.match( target )
				return bot.say( msg.replace( target, match[2] ) )

		# Failing that, scan everyone's messages
		for msg in last_said_general
			if msg.match( target )
				return bot.say( msg.replace( target, match[2] ) )

	# Log everything Everyone says like some kind of stalker
	bot.listen ( from, text ) ->
		last_said_spec[ from ] ?= []

		# Don't save sed commands because just because
		if text.match( sed_regex )
			return

		# Save message to global queue
		last_said_general.unshift( text )
		if last_said_general.length > gen_limit
			last_said_general.pop()

		# And also to personal queue
		last_said_spec[ from ].unshift( text )
		if last_said_spec[ from ].length > spec_limit
			last_said_spec[ from ].pop()
