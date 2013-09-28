
require 'socket'

queue_sockets = Queue.new

puts "Starting up redirect_server..."
accept_server = TCPServer.new(8103)
accept_client = TCPServer.new(8102)


Thread.start do
	puts "Waiting for a server connection"
	while (session_server = accept_server.accept)
	Thread.start do
	   puts "Accepting a server"
	   server_port = session_server.gets
 	   puts "get : " + server_port
	   queue_sockets.push(server_port)
	   session_server.puts "ACK"
	   session_server.close	
	   puts "add a new server with port: " + server_port
	 end  #end thread conversation
	end   #end loop
end

Thread.start do
	puts "Waiting for a client connection"
	while (session_client = accept_client.accept)
		Thread.start do
		puts "Accepting a client"
		to_send = queue_sockets.pop
		puts "to_send " + to_send 
		queue_sockets.push(to_send)
		session_client.puts to_send
		while !(redirect_socket.closed?) &&
                (serverMessage = redirect_socket.gets)
		end #end loop
		puts "Recieved ACK"
		session_client.close
		end  #end thread conversation
	end   #end loop
end

while(true)
end
