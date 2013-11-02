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
    #update the document atrributes
    #destroy the file stored in 
    #update the converted document attributes
    converted_document = self.converted_document
    if status == "OK"
      converted_document.download_link = document_url
      converted_document.size = size
      converted_document.set_to_ready
    else
      converted_document.set_to_failed
    end
    converted_document.save
  end

end
