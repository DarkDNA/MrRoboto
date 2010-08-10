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
	
		puts s.gets
		
		#parse everything into raw commands

		eventStream = s.gets

		split1 = eventStream.split(":")
		
		nicksplit = split1[1].split("!")

		nick = nicksplit[0]

		command = split1.last

		chansplit = eventStream.split

		channel = chansplit[2]

		#create a new object for the bot commands
		botCommands = BotCommands.new(s, nick, channel)

		#the idea here is to send a message to the botCommands class to handle everything

		command_sent = command.split("!").last.strip

		# for some reason it's saying it's not responding to the method but in my test.rb POC it seems to work. Tests below show that the command is a String object as well as being parsed correctly, but when it sees if it responds to it, it fails

#		puts "Command sent: #{command_sent}"
#		puts "Command sent Class: #{command_sent.class}"
#		puts botCommands.respond_to?(command_sent)

		if botCommands.respond_to?(command_sent)
	
#			puts "respondes to command: #{command_sent}"
	
			botCommands.send(command_sent) 
		else
			#not valid command, do nothing
		end

	end


	def run()

		while true
			
			eventHandler(@stream)

		end

	end



end


myBot = MrRoboto.new("wenduri.darkdna.net", 6667, "MrRoboto", "#bots")
#myBot = MrRoboto.new("chat.freenode.net", 6667, "MrRoboooto", "##cisco-offtopic")

myBot.connect()

myBot.run()
