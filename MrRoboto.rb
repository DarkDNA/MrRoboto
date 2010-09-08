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

  def joinChannel(s, channel)

	s.puts("JOIN #{channel}")
 
  end

  # After several revision i decided it would be much easier to have a method parse everything and then set instance
  # variables accordingly

  def parseStream(inputStream)

    # First we take the input stream from the event handler and split it by : to remove the colons at the beginning
    # and end of a raw irc string

    parsedColon = inputStream.split(":") if inputStream.is_a?(String)

    # Here as it turns out the last part of our parsed string is the acutal message inputted by the users. So we store
    # This in an instance variable for the whole object to use
    #@parsedMsg = parsedColon.last
    
    # We also avoid issues with MOTD's having more than 1 : in them by checking to see if our message
    # that is parsed contains 2 or more elemnts, if it does ignore the first 2 elements (0 and 1)
    # and split on the 2nd element and then join the rest 
    # back into a single string, Otherwise just accept the last element that's parsed. I am using [2..-1] which
    #basically says to select everything starting at the 2nd element up to the last element
    @parsedMsg = parsedColon.size  > 2  ? parsedColon[2..-1].join(":") : parsedColon.last

    # Now we need to extract the first element which will be our bot command. Then we take anything after the command as
    # bot command argument, so we split it based on the command itself (in this case the first word in the @parsedMsg
    cmdParse = @parsedMsg.split

    @botCmd = cmdParse[0]
    # store the bot command temporarily and split it up by whitespace so we can sanitize input
    
    # This checks to see if the first parsed letter is a ! and the next is a blank space , which really
    # says "is this ONLY a ! " OR this checks that if the first char in the cmmand is ! and any other
    # char's after the first matches a ! 
 
    if (@botCmd[0,1] == "!" && @botCmd[1,1] == "") || (@botCmd[0,1] == "!" && @botCmd[1..-1] =~ /!/)

      # Invalid command, set @botCmd to nothing
      puts "Invalid Command"
      @botCmd = ""
      
    else
     
      # looks like valid input, lets continue and parse the args out of the parsed message
      botCmdArgsSplit = @parsedMsg.split(@parsedMsg.split.first)

      @botCmdArgs = botCmdArgsSplit[1].strip

    # This might be a bit odd, but we need to strip the ! out of it so we then later send a message to the commands class
      
      @botCmdToSend = @botCmd.split("!").last
      @botCmdToSend = @botCmdToSend.strip if @botCmdToSend.is_a?(String)

    end

   
    # The 2nd element in our parsing contians one long string of a nick!host Message Type Nick or Channel so we store it
    # for parsing
    nickHostMsgChan = parsedColon[1]

    # Now that we have nickHostMsgChan in one string, we parse it by the space as this is the seperator for the majority of it
    parsedSpace = nickHostMsgChan.split 

    # This only happens every so often, but we need to see if the first element is a PING message and if it is we set a flag
    # Denoting it's a ping message and then store the :server portion for later PONG usage

    if parsedColon[0].strip == "PING"
        @isPing = true
        @pongServ = ":#{parsedColon[1]}"
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
    
  
  end # end of method


 def eventHandler(s)

	#Put output to screen
	
	eventStream = s.gets

	puts eventStream

    # Here we call the parser above and prase out each line to see what it is, and we can then peform logic on the instance
    # variables it sets later
    parseStream(eventStream)

    #create a new object for the bot commands and makes it dynamic. If the parsed secion (stored in @nickOrChan) is the same nick as the bot, then that means it's a private message to the bot, so create a new bot object accordingly to respond to the private message. Otherwise it's a channel stream so output stuff to the channel.

    if @nickOrChan == @nick

        botCommands = BotCommands.new(s, @streamNick, @streamNick)
    else
        botCommands = BotCommands.new(s, @nickOrChan, @streamNick)

    end

    # Is the ping flag set? that means we have a ping message, so let's reply accordingly
    if @isPing == true

        botCommands.send(:ping, @pongServ)

    end

    # This has a nasty bug when ! is the only char in the stream it dies
    if @botCmd.include?("!")
        
        # Test to see if our object responds to the parsed method name, if so send it!
        if botCommands.respond_to?(@botCmdToSend)
        
            botCommands.send(@botCmdToSend, @botCmdArgs)

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


