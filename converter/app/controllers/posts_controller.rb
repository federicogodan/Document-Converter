class PostsController < ApplicationController

	def new
	  
	end
  
  def create
      #obtener archivo y combo box 
      
      #esto nose donde va ! (supuestamente esta medio mal que vaya aca)
      require 'socket'
      # establish connection
      ##Telling the client where to connect
      clientSession = TCPSocket.new( "localhost", 8100 )
      puts "log: starting connection"
      #send a request
      ## Note that this has a carriage return. Remember our server
      ## uses the method gets() to get input back from the server. 
      clientSession.puts "Untitled.odt pdf\n"
      #wait for messages from the server
      ## You've sent your message, now we need to make sure
      ## the session isn't closed, spit out any messages the server
      ## has to say, and check to see if any of those messages
      ## contain 'Goodbye'. If they do we can close the connection
       while !(clientSession.closed?) &&
                (serverMessage = clientSession.gets)
        ## lets output our server messages
        puts serverMessage
        #if one of the messages contains 'Goodbye' we'll disconnect
        ## we disconnect by 'closing' the session.
        if serverMessage.include?("Goodbye")
            puts "log: closing connection"
         clientSession.close
        end
       end #end loop
  end
end
