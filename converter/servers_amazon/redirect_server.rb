
require 'socket'

#queue of available server sockets to attend client 
@libreoffice_servers = Array.new
@amazon_nodes = Array.new 
@unoconv_servers = Array.new
#to synchronize the queue
semaphore = Mutex.new

#get parameters through a configuration file 
configuration = eval(File.open('/home/mika/Escritorio/PIS/prototipoMika/Document-Converter/converter/configuration_amazon/redirect.properties') {|f| f.read })
port_servers_unoconv = configuration[:port_servers_unoconv]
port_servers_libreoffice = configuration[:port_servers_libreoffice]
port_unoconv= configuration[:port_unoconv]
port_libreoffice = configuration[:port_libreoffice]
port_size =  configuration[:port_size]

puts "Starting up redirect_server..."
accept_server_uno = TCPServer.new(port_servers_unoconv)
accept_server_libreoffice = TCPServer.new(port_servers_libreoffice)
accept_unoconv = TCPServer.new(port_unoconv)
accept_libreoffice = TCPServer.new(port_libreoffice)
accept_size = TCPServer.new(port_size)

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
	     @unoconv_servers.push unoconv
	     @aux = amazon_nodes.select { |node| node["node_ip"] == unoconv_ip }
	     if @aux.empty? 
		amazon_node = Hash.new
		amazon_node = { "node_ip" => unoconv_ip, "node_load" => 0 } 
		@amazon_nodes.push amazon_node
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
	     server = { "server_ip" => server_ip, "server_port" => server_port, "server_load" => 0} 
	     @libreoffice_servers.push server
	     @aux = @amazon_nodes.select { |node| node["node_ip"] == server_ip }
	     if @aux.empty? 
		amazon_node = Hash.new
		amazon_node = { "node_ip" => server_ip, "node_load" => 0 } 
		@amazon_nodes.push amazon_node
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
			@ok = true
			semaphore.synchronize {
			   puts "Looking for the least loaded node"
			   @amazon_nodes = @amazon_nodes.sort_by { |a| a["node_load"] }
			   puts "Node found: " + @amazon_nodes.first["node_ip"]
			   less_loaded_node = @amazon_nodes.first
			   puts "Looking for the least loaded servers into that node"
			   if  !@libreoffice_servers.empty?
				   less_loaded_servers = @libreoffice_servers.select { |s| s["server_ip"] == less_loaded_node["node_ip"] }
				   puts "Sorting the servers"
				   less_loaded_servers = less_loaded_servers.sort_by { |a| a["server_load"] }
				   puts "Server found, retriving it to the client"   
		  		   @to_send = less_loaded_servers.first
				   puts "Updating server load"  
				   server_selected = @libreoffice_servers.select { |s| s["server_ip"] == @to_send["server_ip"] && s["server_port"]==@to_send["server_port"]}
				   @s = server_selected.first
				   puts "server_load antes"
				   puts @s["server_load"] 
				   @s["server_load"] = @s["server_load"] + size
				   puts "server_load despues"
				   puts @s["server_load"]
				   puts @libreoffice_servers.last
				   puts "port:"	
				   puts @to_send["server_port"]			
				   puts "Updating node load"
				   @amazon_nodes.first["node_load"] = less_loaded_node["node_load"] + size  
				   puts @amazon_nodes.first
			else 
				@ok = false			
			end	
			}
			if (@ok)
				puts  @to_send["server_ip"] + ":" + @to_send["server_port"]
				session_client1.puts @to_send["server_ip"]
				session_client1.puts @to_send["server_port"]
				serverMessage = session_client1.gets.delete("\n")			
				puts "serverMessage"
				puts serverMessage
				if (serverMessage!="ok")
				  	semaphore.synchronize {
						puts "Deleting server libreoffice"
						node = @amazon_nodes.select{|d| d["node_ip"]==@s["server_ip"]}.first
						puts node["node_load"]
						node["node_load"] = node["node_load"] - @s["server_load"]
						@libreoffice_servers.delete(@s)
						puts "Node libreoffice deleted"
					}
				
				end

			else
				puts "Sending error"
				session_client1.puts "error"
				session_client1.gets
			end
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
			   @amazon_nodes.sort_by { |a| a["node_load"] }
			   puts "Node found: " + @amazon_nodes.first["node_ip"]
			   less_loaded_node = @amazon_nodes.first
			   puts "Looking for the least loaded servers into that node"
			   less_loaded_servers = @unoconv_servers.select { |s| s["unoconv_ip"] == less_loaded_node["node_ip"] }
			   puts "Sorting the servers"
			   less_loaded_servers.sort_by { |a| a["unoconv_load"] }
			   puts "Server found, retriving it to the client"   
	  		   @to_send = less_loaded_servers.first
			   puts "Updating unoconv_server load"  
			   #less_loaded_servers.first["unoconv_load"] = size + less_loaded_servers.first["unoconv_load"]
			   #puts "++ " + less_loaded_servers.first["unoconv_load"] 
			   #puts "Updating unoconv_server load"
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

Thread.start do
	while (session_size = accept_size.accept)
		puts "session_size started"
		Thread.start do
			@size = session_size.gets.delete("\n").to_i
			puts @size
			@ip = session_size.gets.delete("\n")
			@port = session_size.gets.delete("\n")
			@param = session_size.gets.delete("\n")
			session_size.puts "ACK"
			semaphore.synchronize {
				if (@param=="L")
					puts "fisrt libreoffice"
					puts @libreoffice_servers.first
					@server_selected = @libreoffice_servers.select { |s| s["server_ip"] == @ip && s["server_port"]== @port }
					 
				else
					@server_selected = @unoconv_servers.select { |s| s["server_ip"] == @ip && s["server_port"]== @port }
				end
				puts "Updating to less server load"
				puts @server_selected
				puts "first"
				@ss = @server_selected.first
				puts "server_load"
				puts @ss["server_load"]
				puts @size
			   	@ss["server_load"] = @ss["server_load"] - @size
				puts "Updating to less node load"
			   	@n = @amazon_nodes.select{ |s| s["node_ip"]==@ip}
			   	@n.first["node_load"] = @n.first["node_load"] - @size
				puts @n.first["node_load"]
				puts "Finish update"
			}
			
		end
	end	
		
end

Thread.start do
end
while(true)   
end
