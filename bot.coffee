## Dependencies ################################################################

fs = require "fs"
{ Client } = require "irc"
{ Database } = require( "sqlite3" ).verbose()

## Bot #########################################################################

## State Variables ##

respond_regex = ///
	^ [/!] (.+)
	|
	^ \s* (?: yew )? bot \W+ (.+)
	|
	(.+?) \W* (?: yew )? bot \W* $
///i
loaded = 0

class YewBot

	## Fields ##

	db: null
	irc: null

	channelTopic: null

	## Constructor ##

	constructor: ->
		# Load SQL Database
		console.log "Loading Database.."
		@db = new Database( "store.db", =>
			console.log "Database Loaded"
			@loadPlugins( loaded++ )
		)

		# Load IRC Client
		console.log "Connecting to IRC Server.."
		@irc = new Client(
			"localhost",
			"YewBot",
			channels: [ "#yewtreemews" ]
		)
		@irc.on "registered", ( msg ) =>
			console.log "Connected to IRC Server"
			loaded++
			@loadPlugins( loaded++ )

		# Add some IRC Events
		@irc.on "topic", ( channel, topic ) =>
			@channelTopic = topic

		@irc.on "message", ( from, to, msg ) ->
			console.log "#{from} => #{to}: #{msg}"
		@irc.on "selfMessage", ( to, msg ) ->
			console.log "me => #{to}: #{msg}"
		@irc.on "join", ( where, who ) ->
			console.log "#{who} joined #{where}"
		@irc.on "part", ( where, who ) ->
			console.log "#{who} left #{where}"
		@irc.on "quit", ( who, reason ) ->
			console.log "#{who} quit the server. Reason: #{reason ? "None"}"

		# Suppress memory leak warning
		@irc.setMaxListeners( 0 )

	## Methods ##

	loadPlugins: ->
		# Only load plugins if both IRC and DB are loaded
		if loaded < 2
			return

		console.log "Loading Plugins.."
		fs.readdirSync( "#{__dirname}/plugins" ).forEach ( plugin ) =>
			try
				require( "./plugins/#{plugin}" )( this )
				console.log "+ Loaded #{plugin}"
			catch err
				console.log "X Failed to load #{plugin}"
				console.trace err

	## IRC Events ##

	onJoin: ( callback ) ->
		@irc.on "join", ( _, who ) ->
			callback( who )

	onLeave: ( callback ) ->
		@irc.on "part", ( _, who ) ->
			callback( who )

	onQuit: ( callback ) ->
		@irc.on "quit", ( who, reason ) ->
			callback( who, reason )

	onKick: ( callback ) ->
		@irc.on "kick", ( _, who, reason, from ) ->
			callback( who, reason, from )

	listen: ( regex, callback ) ->
		if typeof regex == "function"
			@irc.on "message#", ( from, _, text ) ->
				regex( from, text )
		else
			@irc.on "message#", ( from, _, text ) ->
				if match = text.match( regex )
					callback( from, match )

	# TODO: Improve. We don't need to match respond_regex for each command
	respond: ( regex, callback ) ->
		@irc.on "message#", ( from, _, text ) ->
			if match = text.match( respond_regex )
				payload = match[1] ? match[2] ? match[3]
				if match = payload.match( regex )
					callback( from, match )

	pm: ( regex, callback ) ->
		if typeof regex == "function"
			@irc.on "pm", ( from, text ) ->
				callback( from, text )
		else
			@irc.on "pm", ( from, text ) ->
				if match = text.match( regex )
					callback( from, match )

	## IRC Commands ##

	say: ( msg ) ->
		@irc.say( "#yewtreemews", msg )

bot = new YewBot
