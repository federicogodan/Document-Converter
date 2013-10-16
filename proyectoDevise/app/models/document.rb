class Document < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: :document_number
  attr_accessible :creation_date, :document_number, :user_id, :name, :original_extension, :uploading
  belongs_to :user
end
