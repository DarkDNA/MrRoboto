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

def botCommands(s,command)

	case command.strip

		when "!beer"
			puts s.class
			s.puts("PRIVMSG #lobby :Beer for you, Beer for me!")
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

	#get the nick portion by splitting the first element in the parsed array by !
	parsed2 = parsed[1].split("!")

	#the nick is now stored as the first element in the parsed2 array
	nick = parsed2[0]

	#get the command by splitting the string at : and returning the last part
	command = parsed.last

	botCommands(stream,command)

#	case command.strip
#
#		when "!beer"
#			s.puts("PRIVMSG #lobby :\001ACTION Gives #{nick} a beer\001")
#
#		when "!date"
#			date = getDate
#			s.puts("PRIVMSG #lobby :Current Date: #{date}" )
#
#		when "!quit"
#			s.puts("QUIT FFFFUUUUUU")
#	end

end



a = connectToServer("wenduri.darkdna.net", 6667, "boner")

joinChannel(a,"#lobby")
#a.puts("PRIVMSG #test :Meow!")


until a.eof? do

	handleEvents(a)
	puts a.gets

end

