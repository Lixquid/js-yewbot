module.exports = ( bot ) ->

	bot.respond /^rps\W+(\w+)/i, ( from, match ) ->

		choice = switch match[1].toLowerCase()
			when 'r', "rock" then 0
			when 'p', "paper" then 1
			when 's', "scissor" then 2
			else -1

		if choice == -1
			bot.say( "#{from}: I don't know how to play
				Rock, Paper, Scissors, #{match[1]}!" )
			return

		pick = Math.floor( Math.random() * 3 )
		switch pick
			when 0 then bot.say( "#{from}: Ok, rock!" )
			when 1 then bot.say( "#{from}: Ok, paper!" )
			when 2 then bot.say( "#{from}: Ok, scissors!" )

		# Win
		if choice == 0 and pick == 2 or
		  choice == 1 and pick == 0 or
		  choice == 2 and pick == 1
			bot.say( "#{from}: ..Damn." )

		# Draw
		if choice == 0 and pick == 0 or
		  choice == 1 and pick == 1 or
		  choice == 2 and pick == 2
			bot.say( "#{from}: ..Welp." )

		# Lose
		if choice == 0 and pick == 1 or
		  choice == 1 and pick == 2 or
		  choice == 2 and pick == 0
			bot.say( "#{from}: ..Nice." )
