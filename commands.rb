class BotCommands

	def initialize(stream, channel, nick)

		@stream = stream
		@nick = nick
		@channel = channel

	end

	def beer

		@stream.puts("PRIVMSG #{@channel} :\001ACTION gives #{@nick} a beer\001")

	end

	def quit

		users = ["Plazma", "Plazma-Rooolz"]

		users.each { |x|

		if x == @nick

			@stream.puts("QUIT :FFFFFFUUUUUUUU")

		end

		}

		#looks like we aren't a authorized user...

		@stream.puts("PRIVMSG #{@channel} :Sorry #{@nick}, you are not authorized to do that")

	end

	def date
		
		timeNow = Time.now
		currdate = timeNow.strftime("%a %m/%d/%y")

		@stream.puts("PRIVMSG #{@channel} :Today's Date: #{currdate}")
		
	end

	def time

		timeNow = Time.now
		currtime = timeNow.strftime("%I:%M%p")

		@stream.puts("PRIVMSG #{@channel} :Current time: #{currtime}")

	end

	def ping(server)

		puts("PONG #{server}")
		@stream.puts("PONG #{server}")

	end

	def help

		@stream.puts("PRIVMSG #{@channel} :Current commands: !beer , !date , !time, !help")

	end

end
