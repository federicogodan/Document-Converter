class Api::NotificationController < ApplicationController

 def create
    request_body = request.body.read()
    puts params[:message]
    
    
    message = JSON.parse(params[:message])
    puts message
    status = message["status"]
    document_id = message["id"]
    size = message["size"]
    document_url = message["url"]
    puts '='*50
    puts status
    puts document_id
    puts size
    puts document_url
    puts '\n','-'*50
    

    #message = JSON.parse(request_body["Message"])  
    document = Document.find(document_id)
    document.update_converted_document(status, document_url, size.to_i)
    #document.user.alertallwebhooks( document_url )
    #throws an exception but the method works
    begin
      document.remove_file!
    rescue
    end
 
    render :nothing=>true, :status => 200, :content_type => 'text/html'
  end

end
