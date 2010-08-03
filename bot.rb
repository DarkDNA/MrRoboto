require 'socket'

server = "wenduri.darkdna.net"
port = 6667
nick = "Plazma-bot"
channel = "#test"
users = ['Plazma', 'Plazma-Rooolz']

currtime = Time.now
currdate = currtime.strftime("%a %m/%d/%Y")
currnow = currtime.strftime("%I:%M%p")

s = TCPSocket.open(server,port)
s.puts("NICK Plazma-bot")
s.puts("USER Plazma-bot 8 * :Plaazma")
s.puts("JOIN #{channel}")

# until we get to the EOF of the socket do stuff
until s.eof? do

    #Here we match what's currently inputted from the server and if we have a match, we reply
    # The regex says "start at the beginning with : , match a single character or more..etc
    # teh raw command looks like :NICK!IDENT@HOST PRIVMSG #channel :MESSAGE

    case s.gets

	# uses the first captured group as a variable which really is the NICK of the user
    	when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:!beer/
       	    s.puts("PRIVMSG #{channel} :\001ACTION Gives #{$1} a beer\001")

    	when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:!time/
       	    s.puts("PRIVMSG #{channel} :Current time: #{currnow}")

    	when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:!date/
       	    s.puts("PRIVMSG #{channel} :Current date: #{currdate} #{currnow}")

    	when /^:(.+)!(.+?)@(.+?)\sPRIVMSG\s.+\s:!quit/ 
		
		users.each { |x|
		
		# Test to see if the user is in the auth list, if it is we QUIt
		if x == $1
	 	    s.puts("QUIT Beanz and Weenerz!")	
		    puts "#{$1} told me to quit"
		    exit
		end

		}

		#well we didn't quit so the user must not exist in the auth list, so lets deny them
		s.puts("PRIVMSG #{channel} :Sorry #{$1} , you can't do that")
	        puts "#{$1} wasn't authorized and tried to tell me to quit"
		
	else
	    puts s.gets
	
    end

end

    

