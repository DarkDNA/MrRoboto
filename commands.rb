class BotCommands

	def initialize(stream, channel, nick)

		@stream = stream
		@nick = nick
		@channel = channel

	end

	def beer(*args)

        if args[0] == "" || args[0] == "me"
		  @stream.puts("PRIVMSG #{@channel} :\001ACTION gives #{@nick} a beer\001")
	    else
	      @stream.puts("PRIVMSG #{@channel} :\001ACTION gives #{args[0]} a beer\001")
        end

	end
	
	def hug(*args)

      if args[0] == "" || args[0] == "me"
		  @stream.puts("PRIVMSG #{@channel} :\001ACTION gives #{@nick} a big hug.\001")
	  else
	    @stream.puts("PRIVMSG #{@channel} :\001ACTION gives #{args[0]} a big hug.\001")
      end

	end

	def quit(*args)

	    users = ["Plazma", "Plazma-Rooolz"]

		users.each { |x|

		if x == @nick

			puts "QUITTING!"
			@stream.puts("QUIT :FFFFFFUUUUUUUU")
            @stream.close
            exit

		end

		}

		#looks like we aren't a authorized user...

		@stream.puts("PRIVMSG #{@channel} :Sorry #{@nick}, you are not authorized to do that")

	end

	def date(*args)
		
		timeNow = Time.now
		currdate = timeNow.strftime("%a %m/%d/%y")

		@stream.puts("PRIVMSG #{@channel} :Today's Date: #{currdate}")
		
	end

	def time(*args)

		timeNow = Time.now
		currtime = timeNow.strftime("%I:%M%p")

		@stream.puts("PRIVMSG #{@channel} :Current time: #{currtime}")

	end

	def ping(server)

		puts("PONG #{server}")
		@stream.puts("PONG #{server}")

	end

	def help(*args)

        case args[0]

            when ""
		        @stream.puts("PRIVMSG #{@channel} :Current commands: !beer , !date , !time, !help, !say, !hug")

            when "!beer" , "beer"
                @stream.puts("PRIVMSG #{@channel} :Give beer to user. Usage: !beer or !beer <nick>")

            when "!hug", "hug"
                @stream.puts("PRIVMSG #{@channel} :Spread some love with a hug! Usage: !hug or !hug <nick>")

            when "!time", "time"
                @stream.puts("PRIVMSG #{@channel} :Checkin' the time. Usage: !time")

            when "!date", "date"
                @stream.puts("PRIVMSG #{@channel} :What's the date? Usage: !date")

            when "!say", "say"
                @stream.puts("PRIVMSG #{@channel} :Tell me to say things. Usage: !say <message>")

            when "!help", "help"
                @stream.puts("PRIVMSG #{@channel} :Tells you what I can do. Usage: !say <message>")

            else
                @stream.puts("PRIVMSG #{@channel} :Help for command '#{args[0]}' not found")

        end

	end

	def say(message)
	
	  if message == ""
	    @stream.puts("PRIVMSG #{@channel} :This command requires a message to send")
	  else
		  @stream.puts("PRIVMSG #{@channel} :#{message}")
	  end

	end

end
