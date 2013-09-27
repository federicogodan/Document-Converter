class Webhook < ActiveRecord::Base
  validates_uniqueness_of :email, [:deleted, :url]
  attr_accessible :deleted, :email, :url
end
