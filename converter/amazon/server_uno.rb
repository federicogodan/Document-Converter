###
#TODO: catch timeout exception (when the client shutdown by surprise,
# the server must to recover and not explode)
###
###
#TODO: put temporary names to the files because any problem during the convertion 
#with the name of original file 
###

require 'socket'
require 'json'
require 'net/http'
require 'fileutils'

puts "Starting up server..."


#get parameters through a configuration file 
configuration = eval(File.open('/home/ubuntu/configuration/server_uno.properties') {|f| f.read })
port = configuration[:port]
ip = configuration[:ip] 
redirect_ip = configuration[:redirect_ip]
redirect_port = configuration[:redirect_port]
temp = configuration[:temp]
uno = configuration[:uno]
converted = configuration[:converted]
url_backet_put = configuration[:url_backet_put]
url_backet_post = configuration[:url_backet_post] 
uri = configuration[:uri]
tar_name = configuration[:tar_name]
port_size = configuration[:port_size]

Struct.new("Pending", :to_send, :converted_file, :url, :id, :original_size, :original_name, :format_origin) 


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

		@state = "ok"
		puts "to send: "
		puts @pending_work[:to_send]
		system(@pending_work[:to_send])
		puts "try open file"  
		puts @pending_work[:converted_file]
		
		#try open file  
		begin
		    puts "open converted file"
		    file = open(@pending_work[:converted_file])
		    #puts 'renaming original file'
		    File.rename('dir', @pending_work[:original_name])
		    #FileUtils.mv(@pending_work[:converted_file], 'dir/' + @pending_work[:original_name] + '.html')
		    tar_dir = 'tar -czvf ' + tar_name +  @pending_work[:id] +  '.tar ' + @pending_work[:original_name]
		    puts tar_dir
		    system(tar_dir)
		rescue
		        #send error to the client
			@state = "error"   
		end
		if (@state!="error")
                	size = File.size(tar_name + @pending_work[:id] + '.tar') 
                	puts size
                	url_converted = url_backet_put + @pending_work[:id]
                	url = url_converted + '/' + @pending_work[:original_name] + '.tar'
                	puts url
                	system('s3cmd put ' + tar_name +  @pending_work[:id] +  '.tar ' + ' ' + url)
                	url_post = url_backet_post +  @pending_work[:id] + '/' + @pending_work[:original_name] + '.tar'
                	@message = "{\"status\":\"" + @state + "\",\"id\":\"" + @pending_work[:id] + "\",\"size\":\"" + size.to_s + "\",\"url\":\"" + url_post + "\"}"
                	puts "deleting converted file"
                	FileUtils.rm_rf(@pending_work[:original_name])
			FileUtils.rm(tar_name + @pending_work[:id] + '.tar')
			 
		else
			 @message = "{\"status\":\"" + @state + "\",\"id\":\"" + @pending_work[:id] + "\",\"size\":\"" + 0 + "\",\"url\":\"" + "" + "\"}"

		end
                puts "deleting temp file"
		FileUtils.rm(temp + tar_name + @pending_work[:id]  + @pending_work[:format_origin] )
		puts "Sending size to redirect server"
		puts @pending_work[:original_size]
		size_socket = TCPSocket.new(redirect_ip, port_size)	
		size_socket.puts @pending_work[:original_size]			
		size_socket.puts ip
		size_socket.puts port
		size_socket.puts "U"	
		size_socket.gets
		puts "sending post message"
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
          file_format = dict["format"]
          puts file_format
          name = dict["name"]
	  format_origin = File.extname(name)
          puts name
          url = dict["URL"]
          puts url
          id = dict["id"]
          puts id
	  size = dict["size"]
	  puts size
	  session.puts "ACK"
	  puts "close"
	  session.close
	  puts 'temp ' + temp
	  puts 'name ' + tar_name
	  puts 'id ' + id
	  puts 'f ' + format_origin
          system('s3cmd get ' + url + ' ' + temp + tar_name + id  + format_origin) 
	  puts 'system'
	  error = false
	  begin
	    puts "open temp file to check download"
	    file = open(temp + tar_name + id  + format_origin)
	  rescue
	    error = true
	    @message = "{\"status\":\"" + "error" + "\",\"id\":\"" + id + "\",\"size\":\"" + 0 + "\",\"url\":\"\"" + "" + "\"}"
	  end
	  if (!error)
	    to_send = uno + ' -f ' + file_format + ' ' + ' -o ' + converted + ' ' + temp + tar_name + id + format_origin
	    puts to_send	  
	    #building the path of the converted file 
	    converted_file = converted +  tar_name + id +  '.' + file_format
	    puts "converted_file:"
	    puts converted_file
	    #push into queue
	    puts "semaphore"
	    semaphore.synchronize {
	      name_file = name.split(File.extname(name))[0]
	      pending = Struct::Pending.new(to_send, converted_file, url, id, size, name_file, format_origin)
	      queue_pending.push pending
	      puts "push"
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
