class Format < ActiveRecord::Base
  validates_uniqueness_of :name
  attr_accessible :name
  has_many :destiny, class_name: "FileExtension", foreign_key: "can_be_converted_to"
  has_many :origin, class_name: "FileExtension", foreign_key: "extension"
end
