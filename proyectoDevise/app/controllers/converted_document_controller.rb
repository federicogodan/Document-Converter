class ConvertedDocumentController < ApplicationController
  
  #before_filter :authenticate_user!
  
  #remove expired documents from S3
  def self.delete_old_files
    #cds =  ConvertedDocument.joins('INNER JOIN documents ON (converted_documents.document_id = documents.id) INNER JOIN users ON (documents.user_id = users.id) where converted_documents.created_at <= now() - users.documents_time_for_expiration')
    
    
    cds.each do |document|
      AWS::S3::Base.establish_connection!(:access_key_id => 'AKIAI5XVTWY2S636HMWQ', :secret_access_key => '/B1J/ZLzMgqcyLAbvLlgVyPdzwh6WlDRZd7rEYyG')
      AWS::S3::DEFAULT_HOST.replace "s3-website-sa-east-1.amazonaws.com" # "s3-website-us-west-2.amazonaws.com"
      doc = Document.find(document.document_id)
      user = User.find(doc.user_id)
      AWS::S3::S3Object.delete('#{doc.name}'+'.'+'#{doc.format}','uploads/document/file'+'/#{user.id}/')
      
      document.set_to_expired if document.status == 2
    end
  end
end