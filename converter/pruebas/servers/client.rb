file_path = ARGV[0]
format = ARGV[1]
file_name = ARGV[2]
size=ARGV[3].to_i

#TODO: get parameters through a configuration file 

require 'socket'
redirect_socket = TCPSocket.new( "localhost", 8102 )
puts "getting server socket"
server_ip = redirect_socket.gets.delete("\n")
puts "ip: "
puts server_ip 
server_port = redirect_socket.gets.delete("\n").to_i
puts "port: " 
puts server_port
puts "connecting to server"
puts server_ip 
puts server_port
clientSession = TCPSocket.new( server_ip, server_port)
puts "sending ACK"
redirect_socket.puts "ACK" 
clientSession.puts format
clientSession.puts file_name
#system "sudo chmod 777 " + file_path

clientSession.puts size
File.open(file_path, 'r') do |file|  
   while(size - 102400 > 0 ) 
      clientSession.write(file.read(102400))
      size = size - 102400
   end
   clientSession.write(file.read(size))      
end
puts "waiting response"
serverMessage = clientSession.gets
puts "Recieved: " 
puts serverMessage
clientSession.close
