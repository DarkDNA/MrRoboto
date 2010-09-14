require './MrRoboto.rb'

# Need to check to make sure we have the correct # of arguments


# Test  to see if the 2nd argument is a valid number for the port


# Args are 0 = server, 1 = port, 2 = nick, 3 = starting channel

puts ARGV.length

myBot = MrRoboto.new("#{ARGV[0]}", ARGV[1], "#{ARGV[2]}, #{ARGV[3]}")

myBot.connect()

myBot.run()
