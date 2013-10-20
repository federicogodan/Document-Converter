
#get parameters through a configuration file 
configuration = eval(File.open('client.properties') {|f| f.read })
file_path = configuration[:file_path]
format = configuration[:format]
file_name = configuration[:file_name]
size= configuration[:size]
redirect_ip = configuration[:redirect_ip]
redirect_port = configuration[:redirect_port]

require 'socket'
redirect_socket = TCPSocket.new( redirect_ip, redirect_port)
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
