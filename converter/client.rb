file_path = ARGV[0]
format = ARGV[1]
file_name = ARGV[2]
size=ARGV[3].to_i

require 'socket'
redirect_socket = TCPSocket.new( "localhost", 8102 )
puts "getting server socket"
serverMessage = redirect_socket.gets
puts "serverMessage : " + serverMessage
clientSession = TCPSocket.new( "localhost", serverMessage.to_i)
puts "sending ACK"
redirect_socket.puts "ACK" 
clientSession.puts format
clientSession.puts file_name
system "chmod 777 " + file_path

clientSession.puts size
File.open(file_path, 'r') do |file|  
   while(size - 102400 > 0 ) 
      clientSession.write(file.read(102400))
      size = size - 102400
   end
   clientSession.write(file.read(size))      
end
serverMessage = clientSession.gets
puts "Recieved: " 
puts serverMessage
clientSession.close
