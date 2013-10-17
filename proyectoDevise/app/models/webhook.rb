class Webhook < ActiveRecord::Base
  validates_uniqueness_of :user_id, scope: [:deleted, :url]
  attr_accessible :deleted, :user_id, :url
  
  #a Webhook belongs to a single user
  belongs_to :user
end
