class Document < ActiveRecord::Base
  attr_accessible :name, :file
  mount_uploader :file, DocumentUploader
end
