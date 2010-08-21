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

  # After several revision i decided it would be much easier to have a method parse everything and then set instance
  # variables accordingly

  def parseStream(inputStream)

    # First we take the input stream from the event handler and split it by : to remove the colons at the beginning
    # and end of a raw irc string

    parsedColon = inputStream.split(":")

    # Here as it turns out the last part of our parsed string is the acutal message inputted by the users. So we store
    # This in an instance variable for the whole object to use
    #@parsedMsg = parsedColon.last
    @parsedMsg = parsedColon.size > 2 ? parsedColon[2..-1].join(":") : parsedColon.last

    # Now we need to extract the first element which will be our bot command. Then we take anything after the command as
    # bot command argument, so we split it based on the command itself (in this case the first word in the @parsedMsg
    cmdParse = @parsedMsg.split

    @botCmd = cmdParse[0]
    botCmdArgsSplit = @parsedMsg.split(@parsedMsg.split.first)

    @botCmdArgs = botCmdArgsSplit[1].strip

    # This might be a bit odd, but we need to strip the ! out of it so we then later send a message to the commands class
    @botCmdToSend = @botCmd.split("!").last.strip

    # The 2nd element in our parsing contians one long string of a nick!host Message Type Nick or Channel so we store it
    # for parsing
    nickHostMsgChan = parsedColon[1]

    # Now that we have nickHostMsgChan in one string, we parse it by the space as this is the seperator for the majority of it
    parsedSpace = nickHostMsgChan.split 

    # This only happens every so often, but we need to see if the first element is a PING message and if it is we set a flag
    # Denoting it's a ping message and then store the :server portion for later PONG usage

    if parsedSpace[0].strip == "PING"
        @isPing = true
        @pongServ = parsedSpace[1]
    else
        #We can store the message type here (if it's PRIVMSG , NOTICE,  ..etc)
	@isPing = false
        @msgType = parsedSpace[1]
    end

    # This is neat because we can determine later if it's a channel (by the presence of a #) or if it's a nickname
    @nickOrChan = parsedSpace[2]

    # What's left now is the nick!host portion that we store for further parsing
    hostNick = parsedSpace[0]

    # To get the nick by itself, we need to parse at the exclamation point in the raw irc message
    parsedEpt = hostNick.split("!")

    # We now store the nick as a instance variable for the whole object to use
    @streamNick = parsedEpt[0]

  end


	def eventHandler(s)

		#Put output to screen
	
		eventStream = s.gets

		puts eventStream

    # Here we call the parser above and prase out each line to see what it is, and we can then peform logic on the instance
    # variables it sets later
    parseStream(eventStream)

    # Is the ping flag set? that means we have a ping message, so let's reply accordingly
    if @isPing == true

        botCommands.send(:ping, @pongServ.strip)

	  end

		#create a new object for the bot commands and makes it dynamic
		botCommands = BotCommands.new(s, @nickOrChan, @streamNick)

    # This has a nasty bug when ! is the only char in the stream it dies
    if @botCmd.include?("!")
        
        # Test to see if our object responds to the parsed method name, if so send it!
        if botCommands.respond_to?(@botCmdToSend)
        
            botCommands.send(@botCmdToSend, @botCmdArgs)

	    #puts("BOT COMMAND ARGS: #{@botCmdArgs}")

        else

            # must not respond to anything, so we just ignore it
        end


    end

  end



	def run()

		while true
			
			eventHandler(@stream)

		end

	end


end


