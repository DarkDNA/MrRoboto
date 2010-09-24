require './MrRoboto.rb'

# Need to check to make sure we have the correct # of arguments

if ARGV.length != 4
    
    puts "Incorrect number of arguments, requies 4"
    exit

end


# Do to the shell interpreting #channel as a comment, the work around is to enter the channel name
# without the # in it. We append # to it inside the main application file to acutally join the channel

ARGV[3] = "##{ARGV[3]}"

myBot = MrRoboto.new(ARGV[0], ARGV[1], ARGV[2], ARGV[3])

myBot.connect()

myBot.run()

