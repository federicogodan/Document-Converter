class DocumentsFile < ActiveRecord::Base
  validates_uniqueness_of :email, scope: [:document_number, :current_extension]
  attr_accessible :conversion_end_date, :current_extension, :document_number, :download_link, :email, :size_in_bytes, :status
end
