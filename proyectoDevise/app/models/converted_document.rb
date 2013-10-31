class ConvertedDocument < ActiveRecord::Base
  validates_presence_of :current_extension
  
  attr_accessible :created_at, :format_id,
                :download_link, :size_in_bytes, :status
                
  #A converted document belongs to an original document (before the conversion)
  belongs_to :document                
  
  #The converted document belongs to one and only one format
  belongs_to :format  
end
