
require 'socket'
require 'sys/proctable'


puts "Starting up server..."
# establish the server
port = ARGV[0]
#queue of pending conversions
# la cola tiene que ser una estructura para guardar que hay que mandar y a que cliente 
# osea se guarda el to_send que es lo q se tiene q mandar a convertir y el socket del cliente para mandarle ack  
queue_pending = Queue.new
#to synchronize the queue
semaphore = Mutex.new

server = TCPServer.new(port)
redirect_socket = TCPSocket.new("localhost", 8103)
redirect_socket.puts(port)
while !(redirect_socket.closed?) &&
                (serverMessage = redirect_socket.gets)
end #end loop

# setup to listen and accept connections
while (session = server.accept)
Thread.start do
   puts "accepting client"
   format = session.gets.delete("\n")
   puts "format: " + format 
   name = session.gets.delete("\n")
   puts "name: " + name
   size = session.gets.to_i
   puts "size "
   puts  size
   File.open('/home/mika/'+ name, 'w') do |file|
      puts "creating temp file"
     while((size - 102400) > 0 ) ## lets output our server messages
        puts "reading " 
        puts size
        file.write session.read(102400)
        size = size - 102400
     end
     file.write session.read(size)
   end   
   if (format=="txt") 
     format = "txt:Text"
   end
   to_send = '/usr/bin/libreoffice --headless --invisible --convert-to ' + format + ' /home/mika/'+name
   puts "to send " + to_send
   semaphore.synchronize {
    queue_pendig.push to_send
   }
   system(to_send)
   
   #aca hay que intentar abrir el archivo y si existe se elimina de la cola y sino se mata a libreoffice 
   puts "sending ACK"
   session.puts "ACK"
   semaphore.synchronize {
    queue_pendig.pop
   }
   puts "finish"
   
 end  #end thread conversation
end   #end loop
Thread.new #esto hay que cambiarlo , porque no va a ser un hilo que cada cierto tiempo mate a libreoffice 
  while(true) 
    sleep(5.minutes)
    Sys::ProcTable.ps.each { |ps|
        puts ps.cmdline    
        if ps.cmdline.include? "libreoffice"
        puts "libreoffice"
        Process.kill('KILL', ps.pid)
        puts "killing"
        end
     }
     
  end #loop
 end #thread