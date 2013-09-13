class PostsController < ApplicationController

	def new
	  
	end
  
  def create
      #get the format to be convert     
      format = params[:post][:format]
      #get the file 
      #file = params[:post][:file]
      require 'socket'
      # establish connection
      ##Telling the client where to connect
      clientSession = TCPSocket.new( "localhost", 8100 )
      puts "log: starting connection"
      #send the request to the server
      clientSession.puts format
      #wait for messages from the server
       while !(clientSession.closed?) &&
                (serverMessage = clientSession.gets)
        #if one of the messages contains 'Completed' we'll disconnect
        ## we disconnect by 'closing' the session.
        if serverMessage.include?("Completed")
         clientSession.close
        end
       end #end loop
  end
end
