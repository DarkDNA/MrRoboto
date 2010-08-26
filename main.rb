require 'MrRoboto.rb'

myBot = MrRoboto.new("wenduri.darkdna.net", 6667, "MrRoboto", "#bots")
#myBot = MrRoboto.new("chat.freenode.net", 6667, "MrRoboooto", "#botters")
#myBot = MrRoboto.new("localhost", 6667, "MrRoboto", "#bots")
#myBot = MrRoboto.new("irc.efnet.org", 6667, "MrRoboooto", "#bots")

myBot.connect()

myBot.run()
