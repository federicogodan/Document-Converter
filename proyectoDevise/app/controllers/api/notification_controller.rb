class Api::NotificationController < ApplicationController

 def create
    request_body = request.body.read()
        
    message = JSON.parse(params[:message])
    status = message["status"]
    document_id = message["id"]
    size = message["size"]
    document_url = message["url"]
    require 'uri'

    #message = JSON.parse(request_body["Message"])  
    document = Document.find(document_id)
    document.update_converted_document(status, URI.escape(document_url), size.to_i)
    document.user.alertallwebhooks( status, document_url )

    begin
      document.remove_file!
    rescue
    end
 
    render :nothing=>true, :status => 200, :content_type => 'text/html'
  end

end
