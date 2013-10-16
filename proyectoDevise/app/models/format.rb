class Format < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true 
  attr_accessible :name
  #has_many :destiny, class_name: "FileExtension", foreign_key: "can_be_converted_to"
  #has_many :origin, class_name: "FileExtension", foreign_key: "extension"
  
  has_and_belongs_to_many :origin, class_name: "Format", foreign_key: "origin_id"
  has_and_belongs_to_many :destiny, class_name: "Format", foreign_key: "destiny_id"
end
