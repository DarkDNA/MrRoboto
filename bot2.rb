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

def botCommands(stream, command)

end

def handleEvents(s)

stream = s.gets

parsed = stream.split(" :")
#get the command by splitting the string at : and returning the last part

command = parsed.last

puts
puts("Command Parsed: #{command}")
puts
	case command.strip
	
		when "!beer" 
		   s.puts("PRIVMSG #test :Beer for all!") 
	           puts("Detected Beer Command!")	

	end
end



a = connectToServer("wenduri.darkdna.net", 6667, "boner")

joinChannel(a,"#test")
a.puts("PRIVMSG #test :Meow!")


until a.eof? do

	handleEvents(a)
	puts a.gets

end

