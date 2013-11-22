class ConvertedDocumentController < ApplicationController
  
  #before_filter :authenticate_user!
  
  #remove expired documents from S3
  def self.delete_old_files
      cds =  ConvertedDocument.joins('INNER JOIN documents ON (converted_documents.document_id = documents.id) INNER JOIN users ON (documents.user_id = users.id) where converted_documents.created_at <= now() - users.documents_time_for_expiration')    
    
    cds.each do |conv_doc|
      AWS::S3::Base.establish_connection!(:access_key_id => 'AKIAI5XVTWY2S636HMWQ', :secret_access_key => '/B1J/ZLzMgqcyLAbvLlgVyPdzwh6WlDRZd7rEYyG')
      
      #AWS::S3::DEFAULT_HOST.replace 's3-website-sa-east-1.amazonaws.com'
      #AWS::S3::DEFAULT_HOST.replace 's3-website-us-west-2.amazonaws.com'
      AWS::S3::DEFAULT_HOST.replace 's3-sa-east-1.amazonaws.com'
      #AWS::S3::DEFAULT_HOST.replace 's3-us-west-2.amazonaws.com'
      #AWS::S3::DEFAULT_HOST.replace 'magicrepository.s3-website-sa-east-1.amazonaws.com'
      
      doc = Document.find(conv_doc.document_id)
      
      if conv_doc.status == 2
        
        length = doc.name.split('.').length
        doc_name = doc.name.split('.')[0..length-2].join
        
        format_name = Format.find(doc.converted_document.format_id).name.downcase
        
        doc_name += '.' + format_name
        
        AWS::S3::S3Object.delete("uploads/document/file/#{doc.id}/#{doc_name}","magicrepository")
        conv_doc.set_to_expired 
      elsif document.status == 0
        AWS::S3::S3Object.delete("uploads/document/file/#{doc.id}/#{doc.name}","magicrepository")
        conv_doc.set_to_failed
      end
    end
  end
end
