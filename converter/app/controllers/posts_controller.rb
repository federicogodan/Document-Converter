class PostsController < ApplicationController

  def new
    
  end
  
  def create
      require 'socket'
      redirect_socket = TCPSocket.new( "localhost", 8102 )
      puts "getting server socket"
      serverMessage = redirect_socket.gets
      puts "serverMessage : " + serverMessage
      clientSession = TCPSocket.new( "localhost", serverMessage.to_i)
      puts "sending ACK"
      redirect_socket.puts "ACK" 
      format = params[:post][:format]
      clientSession.puts format
      file_name = params[:post][:uploaded_file].original_filename
      clientSession.puts file_name
      file_path = params[:post][:uploaded_file].path
      system "chmod 777 " + file_path
      size = params[:post][:uploaded_file].size
      clientSession.puts size
      File.open(file_path, 'r') do |file|  
           while(size - 102400 > 0 ) 
              clientSession.write(file.read(102400))
              size = size - 102400
           end
           clientSession.write(file.read(size))      
      end
      serverMessage = clientSession.gets
      puts "Recieved: " + serverMessage
      clientSession.close
  end
end
