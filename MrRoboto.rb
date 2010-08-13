require 'socket'
require 'commands.rb'

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
	
	#	puts s.gets
		
		eventStream = s.gets

		puts eventStream


		#parse everything into raw commands

		split1 = eventStream.split(":")
		
		nicksplit = split1[1].split("!")

		nick = nicksplit[0]

		command = split1.last

		chansplit = eventStream.split

		channel = chansplit[2]

		#create a new object for the bot commands and makes it dynamic
		botCommands = BotCommands.new(s, channel, nick)

		#the idea here is to send a message to the botCommands class to handle everything

		command_sent = command.split("!").last.strip

		ping_split = eventStream.split

	#	puts("Ping command = #{ping_split[0].strip}")
	#	puts("Server pinged: #{ping_split[1].strip}")

	if ping_split[0].strip == "PING"

		botCommands.send(:ping, ping_split[1].strip)

	end	


	# check to see if the command has a !, fixes the bug where both beer and !beer would work
	if command.include?("!")

		# command is valid at this point, so parse out the !
		command_sent = command.split("!").last.strip
			
		# see if our class responds/has the appropriate command	

		if botCommands.respond_to?(command_sent)
	
			#send parsed command to commands class
			botCommands.send(command_sent) 
		else
			#not valid command, do nothing
		end

	 end

	end


	def run()

		while true
			
			eventHandler(@stream)

		end

	end



end


#myBot = MrRoboto.new("wenduri.darkdna.net", 6667, "MrRoboto", "#bots")
#myBot = MrRoboto.new("chat.freenode.net", 6667, "MrRoboooto", "##cisco-offtopic")
#myBot = MrRoboto.new("chat.freenode.net", 6667, "MrRoboooto", "##plazma")
myBot = MrRoboto.new("chat.freenode.net", 6667, "MrRoboooto", "#botters")

myBot.connect()

myBot.run()
