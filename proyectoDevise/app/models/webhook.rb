class Webhook < ActiveRecord::Base
  attr_accessible :deleted, :email, :url
end
