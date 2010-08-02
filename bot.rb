require 'socket'

server = "wenduri.darkdna.net"
port = 6667
nick = "Plazma-bot"
channel = "#lobby"

s = TCPSocket.open(server,port)
s.puts("NICK Plazma-bot")
s.puts("USER Plazma-bot 8 * :Plaazma")
s.puts("JOIN #{channel}")
#s.puts("PRIVMSG #{channel} :MEOW!")

# until we get to the EOF of the socket do stuff
until s.eof? do

    if s.gets =~ /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s#lobby\s:!beer/
        s.puts("PRIVMSG #{channel} :Beer for you!")
    end


end

