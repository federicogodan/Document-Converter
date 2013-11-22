require 'socket'
require 'json'
require 'net/http'
require 'fileutils'

puts "Starting up server..."

#the server takes the port as an argument

#get parameters through a configuration file 
configuration = eval(File.open('configuration/libreoffice.properties') {|f| f.read })

port = configuration[:port]
ip = configuration[:ip] 
redirect_ip = configuration[:redirect_ip]
redirect_port = configuration[:redirect_port]
temp = configuration[:temp]
libreoffice = configuration[:libreoffice]
converted = configuration[:converted]
pid_file = configuration[:pid_file]
url_backet_put = configuration[:url_backet_put]
url_backet_post = configuration[:url_backet_post] 
uri = configuration[:uri]
name_temp_file = configuration[:name_temp_file]
port_size = configuration[:port_size]
retries = configuration[:retries]

#configuration parameters: 
puts port
puts ip
puts redirect_ip
puts redirect_port
puts temp
puts libreoffice
puts converted
puts pid_file


Struct.new("Pending", :to_send, :converted_file, :name, :url, :id, :format_dest, :format_origin, :original_size) 
#to_send : command to be executed by the server to make the conversion
#converted_file : path to the converted file
#client_session : client's socket 
#name : file's name
#url: url s3
#id: file's id

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
		count = 0
		while (!ok && count<retries) 
			
			puts	 "to send: "
			puts @pending_work[:to_send]
			system(@pending_work[:to_send])
			puts "try open file"  
			puts @pending_work[:converted_file]
			#try open file  
			begin
			    file = open(@pending_work[:converted_file])
			      ok = true
				puts 'converted file opened'
			    
			    rescue
			      ok = false
			      #the file is broken or it does not exists, 
			      #kill libreoffice 's process and convert again the file
			      #get pid from a file
			      #system('ps -A -o pid,cmd | grep libreoffice > pid_file')
			      puts 'opening pid file'
			      begin
			      	file = File.open(pid_file, "r")
				explode = false
			      rescue
				explode = true
                              end
			      if !explode
				      puts 'opened'
				      line =  file.gets
				      pid = line.match(/\d+/)
				      puts 'closing' 
				      file.close
				      puts 'closed'
				      aux = 'kill ' + pid.to_s
				      puts aux
				      system(aux)
				      #delete file
				      
				      File.delete(pid_file)
				      count = count + 1
			    else
				count = count + 1
			    end
			end
		end #loop ok
		if (ok)
			puts "sending post message"
			file = File.basename(@pending_work[:converted_file]) 
			size = File.size(@pending_work[:converted_file]) 
			puts size
			url_converted = url_backet_put + @pending_work[:id] + '/'
			url = url_converted  + @pending_work[:name] + '.' +  @pending_work[:format_dest]
			puts url
			command = 's3cmd put ' + @pending_work[:converted_file] + ' ' + "\'"+ url + "\'"
			puts command
			system(command)
			url_post = url_backet_post +  @pending_work[:id] + '/' + @pending_work[:name] + '.' +  @pending_work[:format_dest]
			puts url_post
			
			@message = '{"status":"ok","id":"' + @pending_work[:id] + '","size":"' + size.to_s + '","url":"' + url_post + '"}'			
			puts "message"
			puts @message
			puts "deleting converted file"
			FileUtils.rm(@pending_work[:converted_file]) 
		else
			@message = '{"status":"failed","id":"' + @pending_work[:id] + '"}'
		end
		puts "deleting temp file"
		to_delete = temp + name_temp_file + @pending_work[:id] + '.' + @pending_work[:format_origin] 
		puts to_delete
		FileUtils.rm(to_delete)
		puts "Sending size to redirect server"
		puts @pending_work[:original_size]
		size_socket = TCPSocket.new(redirect_ip, port_size)	
		size_socket.puts @pending_work[:original_size]			
		size_socket.puts ip
		size_socket.puts port
		size_socket.puts "L"	
		size_socket.gets
		puts "post"
		puts uri
		uri_post = URI(uri)
		res = Net::HTTP.post_form(uri_post, 'message' => @message)
   end#loop true
end#thread 

#thread that is charged on attending clients and add into queue pending work
Thread.start do
  while(true)  
    Thread.start(server.accept) do |session|
      puts "accepting client"
      message = session.gets.delete("\n")
      puts message
      dict = JSON.parse(message)
      
      format_dest = dict["format"]
      puts format_dest
      name = dict["name"]
      format_origin = File.extname(name)
      url = dict["URL"]
      puts url
      id = dict["id"]
      puts id
      size = dict["size"]
      puts size
      session.puts "ACK"
      session.close
      system('s3cmd get ' + url + ' ' + temp + name_temp_file + id  + format_origin) 
      error = false
      begin
	file = open(temp + name_temp_file + id  + format_origin)
      rescue
	error = true
	@message = "{\"status\":\"" + "error" + "\",\"id\":\"" + id + "\",\"size\":\"0" + "\",\"url\":\"\"" + "" + "\"}"
      end
      if (!error)
	if (format_dest=='txt') 
	    plus = ':Text'
	else
	    plus = ''
	end
	
	to_send = libreoffice+ ' --headless --invisible ' + '--pidfile=' +  pid_file +  ' --convert-to ' + format_dest + plus + ' --outdir ' + converted + ' ' + temp + name_temp_file + id  + format_origin	  
	#building the path of the converted file 
	converted_file = converted + name_temp_file + id + '.' + format_dest
	puts "converted_file:"
	puts converted_file
	#push into queue
	semaphore.synchronize {
	  name_file = name.split(File.extname(name))[0]
	  pending = Struct::Pending.new(to_send, converted_file, name_file , url, id, format_dest, File.extname(name).split('.')[1],size)
	  queue_pending.push pending
	}
	mutex.synchronize {
	    work.signal
	}
      end#if      
    end # thread 
  end#loop 
end#thread 

while(true)   
end
