class Document < ActiveRecord::Base
  validates :user_id, presence: true
  validates :format, presence: true

  attr_accessible :expired, :file, :format_id, :name,
                  :size, :user_id
  
  mount_uploader :file, FileUploader

  #A document belongs to a user, who upload that document for the future conversion
  belongs_to :user
  
  #A document can be converted to many converted documents, depending on the election of the user
  has_one :converted_document
  
  #A document belongs to a unique format
  belongs_to :format
end