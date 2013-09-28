
require 'socket'

puts "Starting up server..."
# establish the server
port = ARGV[0]

server = TCPServer.new(port)
redirect_socket = TCPSocket.new("localhost", 8103)
redirect_socket.puts(port)
while !(redirect_socket.closed?) &&
                (serverMessage = redirect_socket.gets)
end #end loop

# setup to listen and accept connections
while (session = server.accept)
 Thread.start do
   puts "accepting client"
   format = session.gets.delete("\n")
   puts "format: " + format 
   name = session.gets.delete("\n")
   puts "name: " + name
   File.open('/home/mika/'+ name, 'w') do |file|
     file.write (session.read(8079))
   end   
   if (format=="txt") 
     format = "txt:Text"
   end
   to_send = '/usr/bin/libreoffice --headless --invisible --convert-to ' + format + ' /home/mika/'+name
   puts "to send " + to_send
   system(to_send)
   session.puts "ACK"
   session.puts "close"
 end  #end thread conversation
end   #end loop
