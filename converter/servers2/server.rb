###
#TODO: catch timeout exception (when the client shutdown by surprise,
# the server must to recover and not explode)
###


require 'socket'
#require 'sys/proctable'
require 'json'

puts "Starting up server..."

#the server takes the port as an argument

#get parameters through a configuration file 
configuration = eval(File.open('server.properties') {|f| f.read })
port = configuration[:port]
ip = configuration[:ip] 
redirect_ip = configuration[:redirect_ip]
redirect_port = configuration[:redirect_port]
temp = configuration[:temp]
libreoffice = configuration[:libreoffice]
converted = configuration[:converted]
pid_file = configuration[:pid_file]
url_backet = configuration[:url_backet]
uri = configuration[:uri]

#configuration parameters: 
puts port
puts ip
puts redirect_ip
puts redirect_port
puts temp
puts libreoffice
puts converted
puts pid_file
puts url_backet

Struct.new("Pending", :to_send, :converted_file, :client_session, :name, :url, :id) 
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
			
			puts	 "to send: "
			puts @pending_work[:to_send]
			system(@pending_work[:to_send])
			puts "try open file"  
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
			      #get pid from a file
			      system('ps -A -o pid,cmd | grep libreoffice > pid_file')
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
		file = File.open(@pending_work[:converted_file]) 
		size = file.size
		url_converted = url_backet + '/' + @pending_work[:id]
		system('s3cmd put ' + @pending_work[:converted_file] + url_converted)
		message = '{"status":"finish","id":"' + @pending_work[:id] + '","size":"' + size + '","url":"' +
		    url_converted +'/' + file.file_name + '"}'
		puts message
		puts "deleting temp file"
		File.delete(temp + @pending_work[:name])
		File.delete(converted_file)
		puts "client_session"
		uri = URI(uri)
		res = Net::HTTP.post_form(uri, 'message' => message)
		puts res.body
		puts "sending post message"   
   end#loop true
end#thread 

#thread that is charged on attending clients and add into queue pending work
Thread.start do
      while (session = server.accept)
	Thread.start do
	  puts "accepting client"
	  message = session.gets.delete("\n").
	  dict = JSON.parse(message)
	  format = dict["format"]
	  name = dict["name"]
	  url = dict["URL"]
	  id = dict["id"]
	  
	  system('cd ' + temp)
	  system('s3cmd get ' + url)
	  
	  if (format=='txt') #TODO: filter through the format in function of the original one 
	      plus = ':Text'
	  else
	      plus = ''
	  end
	  
	  to_send = libreoffice+ ' --headless --invisible ' + '--pidfile=' +  pid_file +  ' --convert-to ' + format + plus + ' ' + temp + name	  
	  #building the path of the converted file 
	  converted_file = converted + name.split('.')[0] + '.' + format
	  puts "converted_file:"
	  puts converted_file
	  #push into queue
	  semaphore.synchronize {
	    pending = Struct::Pending.new(to_send, converted_file, session, name, url, id) 
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
