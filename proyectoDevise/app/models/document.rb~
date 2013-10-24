class Document < ActiveRecord::Base
  validates :user_id, presence: true
  validates :format, presence: true
  validates :user, presence: true
  validates :document_number, uniqueness: true

  attr_accessible :document_number, :user_id, :name, :file, :creation_date, :format_id
  mount_uploader :file, FileUploader

  #A document belongs to a user, who upload that document for the future conversion
  belongs_to :user
  
  #A document can be converted to many converted documents, depending on the election of the user
  has_many :converted_documents  
  
  #A document belongs to a unique format
  belongs_to :format
  
end
