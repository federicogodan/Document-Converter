
require 'socket'

#queue of available server sockets to attend client 
queue_sockets = Queue.new
#to synchronize the queue
semaphore = Mutex.new


puts "Starting up redirect_server..."
accept_server = TCPServer.new(8103)
accept_client = TCPServer.new(8102)

Thread.start do #thread to attend server
	puts "Waiting for a server connection"
	while (session_server = accept_server.accept)
	Thread.start do
	   puts "Accepting a server"
	   server_port = session_server.gets
	   semaphore.synchronize { #push a new server port to the available sockets queue 
	     queue_sockets.push(server_port)
	     puts"push a new server port"
	   }  
	   session_server.puts "ACK"
	   session_server.close	
	   puts "add a new server with port: " + server_port
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
  		puts @to_send
  		queue_sockets.push(@to_send)
  	}  
  	puts "server port :" + @to_send
  	session_client.puts @to_send
		serverMessage = session_client.gets
		puts "Recieved serverMessage: " + serverMessage
		session_client.close
		end#end thread 
	end#end loop
end

while(true)   
end
