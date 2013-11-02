class NotificationController < ApplicationController

 def create
    request_body = request.body.read()
    puts params[:message]
    puts '='*50
    puts request_body.to_json
    puts '\n','-'*50


    #message = JSON.parse(request_body["Message"])
    document = Document.find(document_id)
    document.update_converted_document(status, document_url, size)
    #throws an exception but the method works
    begin
      document.remove_file!
    rescue
    end
 
    render :nothing=>true, :status => 200, :content_type => 'text/html'
  end

end
