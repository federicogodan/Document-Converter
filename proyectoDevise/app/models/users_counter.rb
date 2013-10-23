class UsersCounter < ActiveRecord::Base
  #Belongs to a user and it's his/her document's counter
  belongs_to :user
  
  
  validates :user_id, uniqueness: true, presence: true
  
  attr_accessible :counter
end
