class Document < ActiveRecord::Base
  validates :user_id, presence: true
  validates :format_id, presence: true

  attr_accessible :expired, :file, :format_id, :name,
                  :size, :user_id
  
  mount_uploader :file, FileUploader

  #A document belongs to a user, who upload that document for the future conversion
  belongs_to :user
  
  #A document can be converted into one converted_document
  has_one :converted_document
  
  #A document belongs to a unique format
  belongs_to :format

  #this function is called when a document finishes his conversion
  def update_converted_document(status, document_url, size)
    #update the document attributes
    #destroy the file stored in 
    #update the converted document attributes
    converted_document = self.converted_document
    if status.upcase == "OK"
      converted_document.download_link = document_url
      converted_document.size = size
      converted_document.conversion_end_date = Time.now()
      converted_document.set_to_ready
      
      converted_document.save #It's necessary because the function time_of_conversion use converted_document.conversion_end_date's value                  
      #updating the bandwidth's information 
      us = self.user       
      #checks that the time_of_conversion's value be a valid value
      if self.time_of_conversion > 0
        us.bandwidth_in_bytes_per_sec += ((size + 3 * self.size) / (self.time_of_conversion * 60)).ceil #the factor 60 is for convert time_of_conversion from mins to secs
      else
        us.bandwidth_in_bytes_per_sec +=  size + 3 * self.size
      end
      us.save
      
    else
      converted_document.set_to_failed
    end
    converted_document.save
  end
  
  def time_of_conversion
    diff_time = 0    
    #conv_doc = ConvertedDocument.find_by_document_id(self.id)
    conv_doc = self.converted_document    
    if !conv_doc.nil?      
        diff_time = conv_doc.conversion_end_date - self.created_at
    end
    (diff_time/60).round(4)
  end

end
