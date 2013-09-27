class Document < ActiveRecord::Base
  validates_uniqueness_of :email, scope: :document_number
  attr_accessible :creation_date, :document_number, :email, :name, :original_extension, :uploading
end
