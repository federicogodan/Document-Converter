###
#TODO: catch timeout exception (when the client shutdown by surprise,
# the server must to recover and not explode)
###


require 'socket'
require 'sys/proctable'

puts "Starting up server..."

#the server takes the port as an argument

#TODO: get parameters through a configuration file 
port = ARGV[0]
ip =  "localhost"
redirect_ip = "localhost"
redirect_port = 8103

Struct.new("Pending", :to_send, :converted_file, :client_session) 
#to_send : command to be executed by the server to make the conversion
#converted_file : path to the converted file
#client_session : client's socket 

#queue of pending conversions which has elements of 'Pending' Objects
queue_pending = Queue.new

#to synchronize the queue
semaphore = Mutex.new

#to notify the thread that there is work to convert
mutex = Mutex.new
work = ConditionVariable.new

#start server connection
server = TCPServer.new(port)
redirect_socket = TCPSocket.new(redirect_ip, redirect_port)
redirect_socket.puts(ip)
redirect_socket.puts(port)
serverMessage = redirect_socket.gets

#thread charged on the conversion, takes an element from the queue and execute the command it 
#and send ACK to the client when the file is converted correctly
Thread.start do
   while(true)
		 puts "initializing conversion thread"
		 @size = 0
		 semaphore.synchronize {
			  @size = queue_pending.size
			  puts "getting size"
		 }
		 if (@size==0) 
		   puts "size=0 waiting to work"
		   mutex.synchronize {
			puts "waiting to work"
			 work.wait(mutex) #waiting that queue has some work to convert
			} 
		 end  
		#get work
		semaphore.synchronize {
			  @pending_work = queue_pending.pop
		}
	
		ok = false
		while (!ok) 
			
			puts @pending_work[:to_send]
			system(@pending_work[:to_send])
			puts "opening file"  
			puts @pending_work[:converted_file]
			#try open file  
			begin
			    file = open(@pending_work[:converted_file])
			    if file 
			      puts "ok"
			      ok = true
			    end
			    rescue
			    #the file is broken or it does not exists, 
			    #kill libreoffice 's process and convert again the file
				    puts "killing libreoffice proccess"
				    Sys::ProcTable.ps.each { |ps|    
					    if ps.cmdline.include? "libreoffice"
					      Process.kill('KILL', ps.pid)
					    end
				    }
			end
		end #loop ok
		puts "client_session"
		@pending_work[:client_session].puts "ACK"
		puts "sending ACK"   
   end#loop true
end#thread 

#thread that is charged on attending clients and add into queue pending work
Thread.start do
      while (session = server.accept)
	Thread.start do
	  puts "accepting client"
	  format = session.gets.delete("\n")
	  name = session.gets.delete("\n")
	  size = session.gets.to_i
	  
	  #TODO: put a relative path instead of '/home/mika'
	  
	  File.open('/home/ubuntu/pruebas/temp2/'+ name, 'w') do |file|
	    puts "creating temp file"
	    while((size - 102400) > 0 ) 
		file.write session.read(102400)
		size = size - 102400
	    end
	    file.write session.read(size)
	  end   
	  if (format=="txt") #TODO: filter through the format in function of the original one 
	      plus = ":Text"
	  else
	  	plus = ''
	  end
	  
	  #TODO: put a relative path instead of '/home/mika'
	  to_send = '/home/ubuntu/LibreOffice_4.1.2.3_Linux_x86_rpm/RPMS/install2/opt/libreoffice4.1/program/soffice --headless --invisible --convert-to ' + format + plus + ' /home/ubuntu/pruebas/temp2/'+ name
	  puts "to send " + to_send
	  
	  #building the path of the converted file 
	  converted_file = '/home/ubuntu/pruebas/' + name.split('.')[0] + '.' + format
	  puts converted_file
	  #push into queue
	  semaphore.synchronize {
	    pending = Struct::Pending.new(to_send, converted_file, session) 
	    queue_pending.push pending
	  }
	  mutex.synchronize {
	      work.signal
	  }
	  end # thread 
      end#loop 
end#thread 

while(true)   
end
