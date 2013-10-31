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
pid_file = configuration[:pid_file]
url_backet_put = configuration[:url_backet_put]
url_backet_post = configuration[:url_backet_post] 
uri = configuration[:uri]
tar_name = configuration[:tar_name]

Struct.new("Pending", :to_send, :converted_file, :client_session, :name, :url, :id) 
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
                puts "sending post message"
                file = File.basename(@pending_work[:converted_file]) 
                size = File.size(tar_name + '.tar ') 
                puts size
                url_converted = url_backet_put + @pending_work[:id]
                url = url_converted + '/' + file
                puts url
                system('s3cmd put ' + tar_name + '.tar ' + ' ' + url)
                url_post = url_backet_post +  @pending_work[:id] + '/' + file
                message = "{\"status\":\"finish\",\"id\":\"" + @pending_work[:id] + "\",\"size\":\"" + size.to_s + "\",\"url\":\"\"" + url_post + "\"}"
                puts message
                puts "deleting temp file"
                File.delete(temp + @pending_work[:name]) 
                FileUtils.rm_rf(converted) 
                puts "client_session"
                puts uri
                uri_post = URI(uri)
                res = Net::HTTP.post_form(uri_post, 'message' => message)
                puts res.body
                puts "sending post message"   
   end#loop true
end#thread 

#thread that is charged on attending clients and add into queue pending work
Thread.start do
      while (session = server.accept)
	Thread.start do
	  puts "accepting client"
	  message = session.gets.delete("\n")
	  puts message
          dict = JSON.parse(message)
          file_format = dict["format"]
          puts file_format
          name = dict["name"]
          puts name
          url = dict["URL"]
          puts url
          id = dict["id"]
          puts id
	  session.puts "ACK"
          system('s3cmd get ' + url + ' ' + temp)
	  to_send = uno + ' -f ' + file_format + ' ' + ' -o ' + converted + ' ' + temp + name 
	  puts to_send	  
	  #building the path of the converted file 
	  converted_file = converted + name.split('.')[0] + '.' + file_format
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
