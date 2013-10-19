class Format < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true 
  attr_accessible :name
  
  #Self join between the origin format to the destinies of formats that the origin can be converted to.
  has_many :destinies, class_name: "Format",
                          foreign_key: "destinies"
  belongs_to :origin, class_name: "Format", foreign_key: "origin"
  
  #A single format could have many documents to be converted
  has_many :documents
  
  #A single format could have many converted documents
  has_many :converted_documents
 
end
