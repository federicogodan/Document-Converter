
require 'socket'

#queue of available server sockets to attend client 
queue_sockets = Array.new
amazon_nodes = Array.new 
unoconv_servers = Array.new
#to synchronize the queue
semaphore = Mutex.new

#get parameters through a configuration file 
configuration = eval(File.open('redirect.properties') {|f| f.read })
port_clients = configuration[:port_clients]
port_servers = configuration[:port_servers]
port_unoconv = configuration[:port_unoconv]

puts "Starting up redirect_server..."
accept_server = TCPServer.new(port_servers)
accept_unoconv = TCPServer.new(port_unoconv)
accept_client = TCPServer.new(port_clients)

Thread.start do #thread to attend a unoconv server
	puts "Waiting for a server connection"
	while (unconv_server = accept_unoconv.accept)
	Thread.start do
	   puts "Accepting a server"
	   unoconv_ip = unoconv_server.gets.delete("\n")
	   unoconv_port = unoconv_server.gets.delete("\n")
	   puts unoconv_ip + ":" + unoconv_port
	   semaphore.synchronize { #push a new server into available servers
	     unoconv = Hash.new
	     unoconv = { "unoconv_ip" => unoconv_ip, "unoconv_port" => unoconv_port, "unoconv_load" => 0 } 
	     unoconv_servers.push server
	     @aux = amazon_nodes.select { |node| node["node_ip"] == unoconv_ip }
	     if @aux.empty? 
		amazon_node = Hash.new
		amazon_node = { "node_ip" => unoconv_ip, "node_load" => 0 } 
		amazon_nodes.push amazon_node
		puts"new Amazon node queued"
	     end  
	   }  
	   session_server.puts "ACK"
	   session_server.close	
	   puts "added a new unoconv server: " + unoconv_ip + ":" + unoconv_port
	 end  #end thread 
	end#end loop
end

Thread.start do #thread to attend server
	puts "Waiting for a server connection"
	while (session_server = accept_server.accept)
	Thread.start do
	   puts "Accepting a server"
	   server_ip = session_server.gets.delete("\n")
	   server_port = session_server.gets.delete("\n")
	   puts server_ip + ":" + server_port
	   semaphore.synchronize { #push a new server into available servers
	     server = Hash.new
	     server = { "server_ip" => server_ip, "server_port" => server_port, "server_load" => 0 } 
	     queue_sockets.push server
	     @aux = amazon_nodes.select { |node| node["node_ip"] == server_ip }
	     if @aux.empty? 
		amazon_node = Hash.new
		amazon_node = { "node_ip" => server_ip, "node_load" => 0 } 
		amazon_nodes.push amazon_node
		puts"new Amazon node queued"
	     end  
	   }  
	   session_server.puts "ACK"
	   session_server.close	
	   puts "added a new server: " + server_ip + ":" + server_port
	 end  #end thread 
	end#end loop
end

Thread.start do
	puts "Waiting for a client connection"
	while (session_client = accept_client.accept)
		Thread.start do
			puts "Accepting a client"
			size = session_client.gets.delete("\n").to_i
			puts size
			@to_send = 0
			semaphore.synchronize {
			   puts "Looking for the least loaded node"
			   amazon_nodes.sort_by { |a| a["node_load"] }
			   puts "Node found: " + amazon_nodes.first["node_ip"]
			   less_loaded_node = amazon_nodes.first
			   puts "Looking for the least loaded servers into that node"
			   less_loaded_servers = queue_sockets.select { |s| s["server_ip"] == less_loaded_node["node_ip"] }
			   puts "Sorting the servers"
			   less_loaded_servers.sort_by { |a| a["server_load"] }
			   puts "Server found, retriving it to the client"   
	  		   @to_send = less_loaded_servers.first
			   puts "Updating server load"  
			   less_loaded_servers.first["server_load"] = size + less_loaded_servers.first["server_load"]
			   puts "++ " + less_loaded_servers.first["server_load"] 
			   puts "Updating server load"
			   less_loaded_node["node_load"] = size + less_loaded_node["node_load"]
			   puts "++ " + less_loaded_node["node_load"] 
			}
			puts  @to_send["server_ip"] + ":" + @to_send["server_port"]
			session_client.puts @to_send["server_ip"]
			session_client.puts @to_send["server_port"]
			serverMessage = session_client.gets
			puts "Recieved serverMessage: " + serverMessage
			session_client.close
		end#end thread 
	end#end loop
end

Thread.start do
	puts "Waiting for a client connection"
	while (session_client = accept_unoconv.accept)
		Thread.start do
			puts "Accepting a client"
			size = session_client.gets.delete("\n").to_i
			puts size
			@to_send = 0
			semaphore.synchronize {
			   puts "Looking for the least loaded node"
			   amazon_nodes.sort_by { |a| a["node_load"] }
			   puts "Node found: " + amazon_nodes.first["node_ip"]
			   less_loaded_node = amazon_nodes.first
			   puts "Looking for the least loaded servers into that node"
			   less_loaded_servers = queue_sockets.select { |s| s["server_ip"] == less_loaded_node["node_ip"] }
			   puts "Sorting the servers"
			   less_loaded_servers.sort_by { |a| a["server_load"] }
			   puts "Server found, retriving it to the client"   
	  		   @to_send = less_loaded_servers.first
			   puts "Updating server load"  
			   less_loaded_servers.first["server_load"] = size + less_loaded_servers.first["server_load"]
			   puts "++ " + less_loaded_servers.first["server_load"] 
			   puts "Updating server load"
			   less_loaded_node["node_load"] = size + less_loaded_node["node_load"]
			   puts "++ " + less_loaded_node["node_load"] 
			}
			puts  @to_send["server_ip"] + ":" + @to_send["server_port"]
			session_client.puts @to_send["server_ip"]
			session_client.puts @to_send["server_port"]
			serverMessage = session_client.gets
			puts "Recieved serverMessage: " + serverMessage
			session_client.close
		end#end thread 
	end#end loop
end

while(true)   
end
