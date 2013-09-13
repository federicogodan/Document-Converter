
require 'socket'
puts "Starting up server..."
# establish the server
## Server established to listen for connections on port 8100
server = TCPServer.new(8100)
# setup to listen and accept connections
while (session = server.accept)
 #start new thread conversation
 ## Here we establish a new thread for a connection client
 Thread.start do
   puts "log: Connection from #{session.peeraddr[2]} at
          #{session.peeraddr[3]}"
   puts "log: got input from client"
   format = session.gets
   format = format.rstrip
   format = format.lstrip
   if (format=="txt") #txt is a particular case that needs :Text after
	   format = "txt:Text"
   end
   #create the string to send to libreoffice 
    to_send = '/usr/bin/libreoffice --headless --invisible --convert-to ' + format + ' ' + 'Untitled.odt'
   puts to_send
   system(to_send)
   session.puts "Server: Welcome #{session.peeraddr[2]}\n"
   # reply   
   puts "log: sending Completed"
   session.puts "Completed"
 end  #end thread conversation
end   #end loop
