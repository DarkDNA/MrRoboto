class BotCommands

	def initialize(channel, nick)

		@nick = nick
		@channel = channel

	end

	def beer

		puts "beer command message passed !"
		@stream.puts("PRIVMSG #{channel} :\001ACTION gives #{@nick} a beer\001")

	end

end

test = BotCommands.new("#beer", "nick")

puts test.respond_to?("beer")
