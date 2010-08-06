require 'socket'

#connect to server and return the stream for monitoring
def connectToServer(server, port, nick)

    s = TCPSocket.open(server,port)
    s.puts("NICK #{nick}")
    s.puts("USER #{nick} 8 * :#{nick}")

    return s
end

#disconnect using QUIT message to ircd , expects open stream
def disconnect(s)
	
	message = "FFFFFUUUUU"
	sleep(1)
	s.puts("QUIT #{message}")    

end

def joinChannel(s,channel)

	s.puts("JOIN #{channel}")

end

def botCommands(s,command,channel,nick)

	case command.strip

		when "!beer"
			s.puts("PRIVMSG #{channel} :\001ACTION gives #{nick} a beer\001")
		
		when "!time"
			time = getTime
			s.puts("PRIVMSG #{channel} :Current Time: #{time}" )

		when "!date"
			date = getDate
			s.puts("PRIVMSG #{channel} :Current Date: #{date}" )
	end



end

def getDate

	timeNow = Time.now
	currdate = timeNow.strftime("%a %m/%d/%y")

	return currdate
end

def getTime

	timeNow = Time.now
	currtime = timeNow.strftime("%I:%M%p")
end

def handleEvents(s)

	stream = s.gets

	parsed = stream.split(":")

	#split on whitespace
	chansplit = stream.split

	channel = chansplit[2]

	#get the nick portion by splitting the first element in the parsed array by !
	parsed2 = parsed[1].split("!")

	#the nick is now stored as the first element in the parsed2 array
	nick = parsed2[0]

	#get the command by splitting the string at : and returning the last part
	command = parsed.last

	case command.strip

		when "!beer"
			botCommands(s,command,channel,nick)

		when "!date"
			botCommands(s,command,channel,nil)

		when "!time"
			botCommands(s,command,channel,nil)

		# We pass nil because when we quit we don't do channel stuff
		when "!quit"
			disconnect(s)
	end

	case stream

		#PING messages are in the format PING :SERVER
		#when /^PING :(.+)$/
		#	puts "#{$1}"

		when parsed[0] == "PING"
			puts "PING?"
			s.puts("PONG :#{parsed[1]}")
			puts "PONG!"

	end


end



#a = connectToServer("chat.freenode.net", 6667, "MrRoboooto")
a = connectToServer("wenduri.darkdna.net", 6667, "MrRoboooto")
#a = connectToServer("irc.efnet.net", 6667, "MrRoboooto")

#joinChannel(a,"#botters")
joinChannel(a,"#lobby")

until a.eof? do

	#pass everything to the event handler
	handleEvents(a)

	#output everything to the console
	puts a.gets

end

