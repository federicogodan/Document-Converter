class Webhoook < ActiveRecord::Base
  attr_accessible :deleted, :url, :user_id
end
