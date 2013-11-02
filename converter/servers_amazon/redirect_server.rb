
require 'socket'

#queue of available server sockets to attend client 
queue_sockets = Array.new
amazon_nodes = Array.new 
unoconv_servers = Array.new
#to synchronize the queue
semaphore = Mutex.new

#get parameters through a configuration file 
configuration = eval(File.open('/home/ubuntu/configuration/redirect.properties') {|f| f.read })
port_servers_unoconv = configuration[:port_servers_unoconv]
port_servers_libreoffice = configuration[:port_servers_libreoffice]
port_unoconv= configuration[:port_unoconv]
port_libreoffice = configuration[:port_libreoffice]
puts "Starting up redirect_server..."
accept_server_uno = TCPServer.new(port_servers_unoconv)
accept_server_libreoffice = TCPServer.new(port_servers_libreoffice)
accept_unoconv = TCPServer.new(port_unoconv)
accept_libreoffice = TCPServer.new(port_libreoffice)

Thread.start do #thread to attend a unoconv server
	puts "Waiting for a server connection"
	while (unoconv_server = accept_server_uno.accept)
	Thread.start do
	   puts "Accepting uno server"
	   unoconv_ip = unoconv_server.gets.delete("\n")
	   unoconv_port = unoconv_server.gets.delete("\n")
	   puts unoconv_ip + ":" + unoconv_port
	   semaphore.synchronize { #push a new server into available servers
	     unoconv = Hash.new
	     unoconv = { "unoconv_ip" => unoconv_ip, "unoconv_port" => unoconv_port, "unoconv_load" => 0 } 
	     unoconv_servers.push unoconv
	     @aux = amazon_nodes.select { |node| node["node_ip"] == unoconv_ip }
	     if @aux.empty? 
		amazon_node = Hash.new
		amazon_node = { "node_ip" => unoconv_ip, "node_load" => 0 } 
		amazon_nodes.push amazon_node
		puts"new Amazon node queued"
	     end  
	   }  
	   unoconv_server.puts "ACK"
	   unoconv_server.close	
	   puts "added a new unoconv server: " + unoconv_ip + ":" + unoconv_port
	 end  #end thread 
	end#end loop
end

Thread.start do #thread to attend server libreoffice
	puts "Waiting for a server connection"
	while (session_server = accept_server_libreoffice.accept)
	Thread.start do
	   puts "Accepting a libreoffice server"
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
	while (session_client1 = accept_libreoffice.accept)
		Thread.start do
			puts "Accepting a client"
			size = session_client1.gets.delete("\n").to_i
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
			   #less_loaded_servers.first["server_load"] = size + less_loaded_servers.first["server_load"]
			   #puts "++ " + less_loaded_servers.first["server_load"] 
			   #puts "Updating server load"
			   #less_loaded_node["node_load"] = size + less_loaded_node["node_load"]
			   #puts "++ " + less_loaded_node["node_load"] 
			}
			puts  @to_send["server_ip"] + ":" + @to_send["server_port"]
			session_client1.puts @to_send["server_ip"]
			session_client1.puts @to_send["server_port"]
			serverMessage = session_client1.gets
			puts "Recieved serverMessage: " + serverMessage
			session_client1.close
		end#end thread 
	end#end loop
end

Thread.start do
	puts "Waiting for a client connection"
	while (session_client2 = accept_unoconv.accept)
		Thread.start do
			puts "Accepting a client"
			size = session_client2.gets.delete("\n").to_i
			puts size
			@to_send = 0
			semaphore.synchronize {
			   puts "Looking for the least loaded node"
			   amazon_nodes.sort_by { |a| a["node_load"] }
			   puts "Node found: " + amazon_nodes.first["node_ip"]
			   less_loaded_node = amazon_nodes.first
			   puts "Looking for the least loaded servers into that node"
			   less_loaded_servers = unoconv_servers.select { |s| s["unoconv_ip"] == less_loaded_node["node_ip"] }
			   puts "Sorting the servers"
			   less_loaded_servers.sort_by { |a| a["unoconv_load"] }
			   puts "Server found, retriving it to the client"   
	  		   @to_send = less_loaded_servers.first
			   puts "Updating server load"  
			   #less_loaded_servers.first["unoconv_load"] = size + less_loaded_servers.first["unoconv_load"]
			   #puts "++ " + less_loaded_servers.first["unoconv_load"] 
			   #puts "Updating server load"
			   #less_loaded_node["node_load"] = size + less_loaded_node["node_load"]
			   #puts "++ " + less_loaded_node["node_load"] 
			}
			puts  @to_send["unoconv_ip"]  + ":" + @to_send["unoconv_port"]
			session_client2.puts @to_send["unoconv_ip"]
			session_client2.puts @to_send["unoconv_port"]
			serverMessage = session_client2.gets
			puts "Recieved serverMessage: " + serverMessage
			session_client2.close
		end#end thread 
	end#end loop
end

while(true)   
end
