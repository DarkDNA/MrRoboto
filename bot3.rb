require 'socket'

class MrRoboto
	
	#This is just the connection info that gets passed when we create our new bot object
	def initialize(server, port, nick, startchan)

		@server = server
		@port = port
		@nick = nick
		@startchan = startchan

	end

	#this method just does the connecting by sending raw IRC commands
	def connect()
	
		@stream = TCPSocket.open(@server, @port)
		@stream.puts("NICK #{@nick}")
		@stream.puts("USER #{@nick} 8 * :#{@nick}")
		@stream.puts("JOIN #{@startchan}")
	
	end

	def disconnect(s)

		s.puts("QUIT FFFFFUUUU")	

	end

	def joinChannel(s, channel)

		s.puts("JOIN #{channel}")
 
	end

	def eventHandler(s)

		#Put output to screen
	
		puts s.gets
		
		#parse everything into raw commands

		eventStream = s.gets

		split1 = eventStream.split(":")
		
		nicksplit = split1[1].split("!")

		nick = nicksplit[0]

		command = split1.last

		chansplit = eventStream.split

		channel = chansplit[2]


		case command.strip

			when "!beer"
				s.puts("PRIVMSG #{channel} :\001ACTION gives #{nick} a beer\001")	
			when "!quit"
				disconnect(s)
		end

	end


	def run()

		while true
			
			eventHandler(@stream)

		end

	end



end


myBot = MrRoboto.new("wenduri.darkdna.net", 6667, "MrRoboto", "#lobby")

myBot.connect()

myBot.run()
