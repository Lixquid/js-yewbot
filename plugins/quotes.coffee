module.exports = ( bot ) ->

	## Database ##

	bot.db.run( "
		CREATE TABLE IF NOT EXISTS quotes (
			id INTEGER PRIMARY KEY,
			quote TEXT UNIQUE
		)
	" )

	## Message buffer ##

	last_id = null
	last_msg = null

	bot.listen ( from, msg ) ->
		# Delay so as not to catch "save that" commands
		setTimeout( ( ->
			last_msg = from + ": " + msg
		), 0 )

	## Save Command ##
	bot.respond /^save that/i, ( from ) ->
		if not last_msg
			return

		bot.db.run( "INSERT INTO quotes ( quote ) VALUES ( ? )", last_msg, ->
			last_id = @lastID
		)

		bot.say( "#{from}: Saved!" )

	## Remvoe Command
	bot.respond /^forget (about )?that/i, ( from ) ->
		if not last_id
			bot.say( "#{from}: Forget about what?" )
			return

		bot.db.run( "DELETE FROM quotes WHERE id = ?", last_id )
		last_id = null
		bot.say( "#{from}: Forgotten." )

	## Randomly Spout Shit ##
	emit_quote = ->
		bot.db.get( "
			SELECT id, quote
			FROM quotes
			ORDER BY RANDOM() LIMIT 1", ( err, row ) ->
				if err or not row
					return

				last_msg = row.quote
				last_id = row.id

				bot.say( last_msg )
		)
	setInterval( emit_quote, 30 * 60 * 1000 )
	bot.respond( /^give me banter/i, emit_quote )
