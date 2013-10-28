
require 'socket'
require 'sys/proctable'

puts "Starting up server..."

#the server takes the port as an argument
port = ARGV[0]

#get parameters through a configuration file 
configuration = eval(File.open('server_uno.properties') {|f| f.read })
ip = configuration[:ip] 
redirect_ip = configuration[:redirect_ip]
redirect_port = configuration[:redirect_port]
temp = configuration[:temp]
uno = configuration[:uno]
converted = configuration[:converted]
pid_file = configuration[:pid_file]
tar_name = configuration[:tar_name]

#configuration parameters: 
#puts ip
#puts redirect_ip
#puts redirect_port
#puts temp
#puts uno
#puts converted
#puts pid_file
#puts tar_name

Struct.new("Pending", :to_send, :converted_file, :client_session, :name) 
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
			
			puts "to send: "
			puts @pending_work[:to_send]
			system(@pending_work[:to_send])
			puts "try open file"  
			puts @pending_work[:converted_file]
			#try open file  
			begin
			    file = open(@pending_work[:converted_file])
			    if file 
			      system('tar -czvf ' + tar_name + '.tar ' + converted)
			      ok = true
			    end
			    rescue
			      #the file is broken or it does not exists, 
			      #kill libreoffice 's process and convert again the file
			      #get pid from a file
			      system('ps -A -o pid,cmd | grep soffice > pid_file')
			      file = File.open(pid_file, "r")
			      line =  file.gets
			      pid = line.match(/\d+/) 
			      file.close
			      aux = 'kill ' + pid.to_s
			      puts aux
			      system(aux)
			      #delete file
			      File.delete(pid_file)
			end
		end #loop ok
		puts "deleting temp files"
		File.delete(temp + @pending_work[:name])
		system('rm -r ' + converted)
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
	  puts name
	  size = session.gets.to_i
	  
	  #TODO: put a relative path instead of '/home/mika'
	  
	  File.open(temp + name, 'w') do |file|
	    puts "creating temp file"
	    while((size - 102400) > 0 ) 
		file.write session.read(102400)
		size = size - 102400
	    end
	    file.write session.read(size)
	  end
	  system('chmod -R 777 ' + temp)
	    
	  if (format=='txt') #TODO: filter through the format in function of the original one 
	      plus = ':Text'
	  else
	      plus = ''
	  end
	  
	  puts "plus: "
	  puts plus
	  puts "to_send:"
	  to_send = uno + ' -f ' + format + ' ' + ' -o ' + converted + ' ' + temp + name 
	  puts to_send	  
	  #building the path of the converted file 
	  converted_file = converted + name.split('.')[0] + '.' + format
	  puts "converted_file:"
	  puts converted_file
	  #push into queue
	  semaphore.synchronize {
	    pending = Struct::Pending.new(to_send, converted_file, session, name) 
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
