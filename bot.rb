require 'socket'

server = "wenduri.darkdna.net"
port = 6667
nick = "Plazma-bot"
channel = "#lobby"
currtime = Time.now

s = TCPSocket.open(server,port)
s.puts("NICK Plazma-bot")
s.puts("USER Plazma-bot 8 * :Plaazma")
s.puts("JOIN #{channel}")
#s.puts("PRIVMSG #{channel} :MEOW!")

# until we get to the EOF of the socket do stuff
until s.eof? do

    #Here we match what's currently inputted from the server and if we have a match, we reply
    # The regex says "start at the beginning with : , match a single character or more..etc
    # teh raw command looks like :NICK!IDENT@HOST PRIVMSG #channel :MESSAGE

    case s.gets

    	when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s#lobby\s:!beer/
       	    s.puts("PRIVMSG #{channel} :Beer for #{$1}")

    	when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s#lobby\s:!time/
       	    s.puts("PRIVMSG #{channel} :Current time: #{currtime}")

    	when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s#lobby\s:!quit/
       	    s.puts("QUIT Franks and Beanz!")
	
	else
	    puts s.gets
	
    end

    if s.eof?
	s.puts("QUIT Cut down in my prime!")
    end

end

