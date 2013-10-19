class ConvertedDocument < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: [:document_number, :current_extension]
  validates_presence_of :user_id, :document_number, :current_extension
  
  attr_accessible :conversion_end_date, :current_extension, :document_number, 
                :download_link, :user_id, :size_in_bytes, :status
                
  #A converted document belongs to an original document (before the conversion)
  belongs_to :document                
  
  #The converted document belongs to one and only one format
  belongs_to :format  
end
