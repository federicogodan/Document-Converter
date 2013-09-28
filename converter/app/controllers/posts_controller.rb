class PostsController < ApplicationController

  def new
    
  end
  
  def create
      require 'socket'
      redirect_socket = TCPSocket.new( "localhost", 8102 )
      serverMessage = redirect_socket.gets
      clientSession = TCPSocket.new( "localhost", serverMessage.to_i)
      puts "sending ACK"
      redirect_socket.puts "ACK" 
      puts "obteniendo formato"
      format = params[:post][:format]
      clientSession.puts format
      file_name = params[:post][:uploaded_file].original_filename
      file_path = params[:post][:uploaded_file].path
      system ("chmod 777 " + file_path)
      puts params[:post][:uploaded_file].size
      File.open(file_path, 'r') do |file|     
          clientSession.write(file.read(8079))
      end
      puts("finish")
       while !(clientSession.closed?) &&
                (serverMessage = clientSession.gets)
        ## lets output our server messages
        puts serverMessage
        if serverMessage.include?("Goodbye")
         clientSession.close
        end
       end #end loop
  end
end
