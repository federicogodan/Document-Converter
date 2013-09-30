class Webhook < ActiveRecord::Base
  validates_uniqueness_of :user_id, [:deleted, :url]
  attr_accessible :deleted, :user_id, :url
end
