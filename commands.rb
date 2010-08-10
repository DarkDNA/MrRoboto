class BotCommands

	def initialize(stream, channel, nick)

		@stream = stream
		@nick = nick
		@channel = channel

	end

	def beer

		@stream.puts("PRIVMSG #{@channel} :\001ACTION gives #{@nick} a beer\001")

	end

end
