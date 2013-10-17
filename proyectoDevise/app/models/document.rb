class Document < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: :document_number
  attr_accessible :creation_date, :document_number, :user_id, :name, :original_extension, :uploading

  #A document belongs to a user, who upload that document for the future conversion
  belongs_to :user
  
  #A document can be converted to many converted documents, depending on the election of the user
  has_many :converted_documents  
  
  #A document belongs to a unique format
  belongs_to :format
end
