
require 'socket'
require 'sys/proctable'
require 'time'

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
   size = session.gets.to_i
   puts "size "
   puts  size
   File.open('/home/mika/'+ name, 'w') do |file|
      puts "creating temp file"
     while((size - 1024) > 0 ) ## lets output our server messages
        puts "reading " 
        puts size
        file.write session.read(1024)
        size = size - 1024
     end
     file.write session.read(size)
   end   
   if (format=="txt") 
     format = "txt:Text"
   end
   to_send = '/usr/bin/libreoffice --headless --invisible --convert-to ' + format + ' /home/mika/'+name
   puts "to send " + to_send
   system(to_send)
   puts "sending ACK"
   session.puts "ACK"
   Sys::ProcTable.ps.each { |ps|
      if ps.name.downcase == "libreoffice".downcase
        puts "libreoffice"
        Process.kill('KILL', ps.pid)
        puts "killing"
      end
    }
   puts "finish"
   
 end  #end thread conversation
end   #end loop
