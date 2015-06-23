## Dependencies ################################################################

repl = require "repl"
irc = require "irc"

## Boilerplate #################################################################

client = new irc.Client(
	"localhost",
	"REPL",
	channels: [ "#yewtreemews" ]
)

# Log Messages
client.addListener "message", ( from, to, msg ) ->
	console.log "#{from} => #{to}: #{msg}"
client.addListener "join", ( where, who ) ->
	console.log "#{who} joined #{where}"
client.addListener "part", ( where, who, why ) ->
	console.log "#{who} left #{where}#{if why then ': ' + why else ''}"

cmd = repl.start(
	prompt: "IRC> "
	eval: ( msg ) ->
		client.say( "#yewtreemews", msg )
)
