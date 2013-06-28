hubot = require 'hubot'
mineflayer = require 'mineflayer'

class MineflayerAdapter extends hubot.Adapter
	send: (username, messages...) ->
		for message in messages
			@bot.chat message unless username is @bot.username

	reply: (username, messages...) ->
		for message in messages
			@bot.whisper username, message unless username is @bot.username

	run: ->
		self = @

		@bot = mineflayer.createBot
			host: process.env.HUBOT_MINECRAFT_HOST
			port: +process.env.HUBOT_MINECRAFT_PORT
			username: process.env.HUBOT_MINECRAFT_USERNAME
			password: process.env.HUBOT_MINECRAFT_PASSWORD

		@bot.on 'login', =>
			console.log "#{ @robot.name } has entered the server"
			@bot.chat "Hello everyone, #{ @robot.name } here at your service."

		@bot.on 'end', =>
			@receive new hubot.LeaveMessage

		@bot.on 'chat', (username, message) =>
			user = new hubot.User username
			textMessage = new hubot.TextMessage user, message, 'messageId'
			@receive textMessage

		@bot.on 'whisper', (username, message) =>
			user = new hubot.User username
			textMessage = new hubot.TextMessage user, message, 'messageId'
			@receive textMessage

		@emit 'connected'

exports.use = (robot) ->
	new MineflayerAdapter robot