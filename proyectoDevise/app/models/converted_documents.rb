class ConvertedDocuments < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: [:document_number, :current_extension]
  attr_accessible :conversion_end_date, :current_extension, :document_number, 
                :download_link, :user_id, :size_in_bytes, :status
end
