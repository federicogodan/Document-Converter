class FileExtension < ActiveRecord::Base
  validates_uniqueness_of :can_be_converted_to, scope: :extension
  attr_accessible :can_be_converted_to, :extension
  
  belongs_to :can_be_converted_to, class_name: "Format"
  belongs_to :extension, class_name: "Format"
end
