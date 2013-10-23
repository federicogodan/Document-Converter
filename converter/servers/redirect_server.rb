
require 'socket'

#queue of available server sockets to attend client 
queue_sockets = Queue.new
#to synchronize the queue
semaphore = Mutex.new
Struct.new("Server", :server_ip, :server_port) 

#get parameters through a configuration file 
configuration = eval(File.open('redirect.properties') {|f| f.read })
port_clients = configuration[:port_clients]
port_servers = configuration[:port_servers]

puts "Starting up redirect_server..."
accept_server = TCPServer.new(port_servers)
accept_client = TCPServer.new(port_clients)

Thread.start do #thread to attend server
	puts "Waiting for a server connection"
	while (session_server = accept_server.accept)
	Thread.start do
	   puts "Accepting a server"
	   server_message = session_server.gets.delete("\n").split(",")
	   server_ip = server_message[0] 
	   server_port = server_message[1]
	   server_type = server_message[2] #esto es para despues meterlos en distintas colas segun sea U o L el server_type  
	   puts server_ip + ":" + server_port + ":" + server_type
	   semaphore.synchronize { #push a new server into available servers 
	     server = Struct::Server.new(server_ip, server_port) 
	     queue_sockets.push server
	     puts"push a new server into queue"
	   }  
	   session_server.puts "ACK"
	   session_server.close	
	   puts "added a new server: " +  + server_ip + ":" + server_port
	 end  #end thread 
	end#end loop
end

Thread.start do
	puts "Waiting for a client connection"
	while (session_client = accept_client.accept)
		Thread.start do
		puts "Accepting a client"
		@to_send = 0
		semaphore.synchronize {
  		@to_send = queue_sockets.pop
		queue_sockets.push @to_send
		}
		puts  @to_send[:server_ip] + ":" + @to_send[:server_port]
		session_client.puts @to_send[:server_ip]
		session_client.puts @to_send[:server_port]
		serverMessage = session_client.gets
		puts "Recieved serverMessage: " + serverMessage
		session_client.close
		end#end thread 
	end#end loop
end

while(true)   
end
