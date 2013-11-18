
require 'socket'

#queue of available server sockets to attend client 
@libreoffice_servers = Array.new
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

Thread.start do #thread to attend a unoconv servers
  puts "Waiting for a server connection"
  while(true)
    Thread.start(accept_server_uno.accept) do |unoconv_server| 
      puts "Accepting uno server"
      unoconv_ip = unoconv_server.gets.delete("\n")
      unoconv_port = unoconv_server.gets.delete("\n")
      puts unoconv_ip + ":" + unoconv_port
      semaphore.synchronize { #push a new server into available servers
	
	unoconv = Hash.new
	unoconv = { "unoconv_ip" => unoconv_ip, "unoconv_port" => unoconv_port, "unoconv_load" => 0 } 
	@unoconv_servers.push unoconv
	puts @unoconv_servers 
	
      }  
      unoconv_server.puts "ACK"
      unoconv_server.close	
      puts "added a new unoconv server: " + unoconv_ip + ":" + unoconv_port
    end  #end thread 
  end#end loop
end#unoconv servers

Thread.start do #thread to attend libreoffice servers 
  while(true)  
    Thread.start(accept_server_libreoffice.accept) do |session_server| 
      puts "Accepting a libreoffice server"
      server_ip = session_server.gets.delete("\n")
      server_port = session_server.gets.delete("\n")
      
      puts server_ip + ":" + server_port
      semaphore.synchronize { #push a new server into available servers
	server = Hash.new
	server = { "server_ip" => server_ip, "server_port" => server_port, "server_load" => 0} 
	@libreoffice_servers.push server
      }  
      session_server.puts "ACK"
      session_server.close	
      puts "added a new server: " + server_ip + ":" + server_port
    end  #end thread 
  end#end loop
end#libreoffice servers

Thread.start do #thread to attend libreoffice clients 
  while(true)  
    Thread.start(accept_libreoffice.accept) do |session_client| 
      puts "Accepting a client"
      size = session_client.gets.delete("\n").to_i
      puts size
      @to_send = 0
      @ok = true
      semaphore.synchronize {
	 
	  if  !@libreoffice_servers.empty?
	    less_loaded_servers = @libreoffice_servers.sort_by { |a| a["server_load"] }
	    puts "Server found, retriving it to the client"   
	    @s = less_loaded_servers.first 
	    puts "server_load before"
	    puts @s["server_load"] 
	    @s["server_load"] = @s["server_load"] + size
	    puts "server_load after"
	    puts @s["server_load"]
	   else 
	    @ok = false			
	   end	
      }
      if (@ok)
	puts  @s["server_ip"] + ":" + @s["server_port"]
	session_client.puts @s["server_ip"]
	session_client.puts @s["server_port"]
	serverMessage = session_client.gets.delete("\n")			
	puts "serverMessage"
	puts serverMessage
	if (serverMessage!="ok")
	  semaphore.synchronize {
	    puts "Deleting server libreoffice"
	    @libreoffice_servers.delete(@s)
	    puts "Node libreoffice deleted"
	  }
	end
      else
	puts "Sending error"
	session_client.puts "error"
	session_client.gets
      end
      session_client.close		    
    end#end thread 
    end#end loop
end# libreoffice clients

Thread.start do #thread to attend unoconv clients 
  while(true)  
    Thread.start(accept_unoconv.accept) do |session_client| 
      puts "Accepting a client"
      size = session_client.gets.delete("\n").to_i
      puts size
      @to_send = 0
      @ok = true
      semaphore.synchronize {
	  
	  if  !@unoconv_servers.empty?
	    less_loaded_servers = @unoconv_servers.sort_by { |a| a["unoconv_load"] }
	    puts "Server found, retriving it to the client"   
	    @s = less_loaded_servers.first 
	    puts "unoconv_load before"
	    puts @s["unoconv_load"] 
	    @s["unoconv_load"] = @s["unoconv_load"] + size
	    puts "unoconv_load after"
	    puts @s["unoconv_load"]
	   else 
	    @ok = false			
	   end	
      }
      if (@ok)
	puts  @s["unoconv_ip"] + ":" + @s["unoconv_port"]
	session_client.puts @s["unoconv_ip"]
	session_client.puts @s["unoconv_port"]
	serverMessage = session_client.gets.delete("\n")			
	puts "serverMessage"
	puts serverMessage
	if (serverMessage!="ok")
	  semaphore.synchronize {
	    puts "Deleting server unoconv"
	    @unoconv_servers.delete(@s)
	    puts "Node unoconv deleted"
	  }
	end
      else
	puts "Sending error"
	session_client.puts "error"
	session_client.gets
      end
      session_client.close		    
    end#end thread 
    end#end loop
end# unoconv clients

Thread.start do #thread to update server and node load
  while(true)  
    Thread.start(accept_size.accept) do |session_size|
      puts "session_size started"
      @size = session_size.gets.delete("\n").to_i
      puts @size
      @ip = session_size.gets.delete("\n")
      @port = session_size.gets.delete("\n")
      @param = session_size.gets.delete("\n")
      session_size.puts "ACK"
      session_size.close
      semaphore.synchronize {
	if (@param=="L")
	  puts "libreoffice"
	  @server_selected = @libreoffice_servers.select { |s| s["server_ip"] == @ip && s["server_port"]== @port }
	else
	  puts "unoconv"
	  @server_selected = @unoconv_servers.select { |s| s["server_ip"] == @ip && s["server_port"]== @port }
	end
	@ss = @server_selected.first
	@ss["server_load"] = @ss["server_load"] - @size
	puts "server load"
	puts @ss["server_load"]
      }
    end#end treath
  end#end loop			
end#load

while(true) 
  #always must be running 
end
