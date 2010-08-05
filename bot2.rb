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
	
	puts("Quitting IRCD")

	s.puts("QUIT FFFFUUUUU")    

end

def joinChannel(s,channel)

	s.puts("JOIN #{channel}")

end

def botCommands(s,command,channel)

	case command.strip

		when "!beer"
			puts s.class
			s.puts("PRIVMSG #{channel} :Beer for you, Beer for me!")
		
		when "!quit"
			s.puts("QUIT FFFFFUUUU")

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
			botCommands(s,command,channel)

		when "!date"
			date = getDate
			botCommands(s,command,channel)

		# We pass nil because when we quit we don't do channel stuff
		when "!quit"
			botCommands(s,command,nil)
	end

	case stream

		when /^PING :(.+)$/
			puts "#{$1}"
	end


end



a = connectToServer("wenduri.darkdna.net", 6667, "boner")

joinChannel(a,"#lobby")
#a.puts("PRIVMSG #test :Meow!")


until a.eof? do

	handleEvents(a)
	puts a.gets

end

