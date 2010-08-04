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

	s.puts("QUIT Beanz and Weenerz!")    

end

def joinChannel(s,channel)

	s.puts("JOIN #{channel}")

end


a = connectToServer("wenduri.darkdna.net", 6667, "boner")

joinChannel(a,"#lobby")
a.puts("PRIVMSG #lobby :Meow!")
disconnect(a)

until a.eof? do

	puts a.gets
end

