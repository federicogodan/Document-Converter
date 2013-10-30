class PostsController < ApplicationController

  def new
    
  end
  
  def create
      require 'socket'
      redirect_socket = TCPSocket.new( "177.71.195.102", 8102 )
      puts "getting server socket"
      
      server_ip = redirect_socket.gets.delete("\n")
      server_port = redirect_socket.gets.delete("\n").to_i   
      
      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      puts server_ip
      puts server_port
      
      clientSession = TCPSocket.new( server_ip , server_port)
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
      
      #Association between user and document
      us = User.find_by_nick(cookies[:nickname])      
      uc = UsersCounter.find_by_user_id(us.id)      
      doc = Document.new(document_number:doc_number,name:file_name,uploading:true)
      File.extname(params[:post][:uploaded_file].original_filename)       
      doc.user = us
      doc.save
      us.documents.push(doc)
      us.save
      
      #actualizing the counter's column
      uc.update_attributes(counter:doc_number + 1)
      uc.save
      
      
      File.open(file_path, 'r') do |file|  
           while(size - 102400 > 0 ) 
              clientSession.write(file.read(102400))
              size = size - 102400
           end
           clientSession.write(file.read(size))      
      end
      puts "waiting response"
      serverMessage = clientSession.gets
      puts "Recieved: " 
      puts serverMessage
      clientSession.close
  end
  
end
