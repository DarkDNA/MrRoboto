require 'socket'

server = "wenduri.darkdna.net"
port = 6667
nick = "Plazma-bot"
channel = "#lobby"
users = ["Plazma", "Plazma-Rooolz"]

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
       	    s.puts("PRIVMSG #{channel} :Beer for #{$1}")

    	when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:!time/
       	    s.puts("PRIVMSG #{channel} :Current time: #{currnow}")

    	when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:!date/
       	    s.puts("PRIVMSG #{channel} :Current date: #{currdate} #{currnow}")

    	when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:!quit/ 
	    users.each { |x| 
		puts("----------- DEBUG ------------")
		puts("x passed to block: #{x}")
		puts
		puts("First captured group {$1}: #{$1}")
		puts("x class: #{x.class}")
		puts("first capture class: #{$1.class}")
		puts("-----------END DEBUG --------")
		#if the first captured part of the event (which is the nick) matches our listof users
	   	if #{x} == #{$1} 
	 	    s.puts("QUIT Franks and Beanz!")	
		else
		    s.puts("Sorry #{x} , you can't do that")
		end
            }
	else
	    puts s.gets
	
    end

end

    

