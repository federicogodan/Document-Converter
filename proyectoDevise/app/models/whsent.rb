class Whsent < ActiveRecord::Base
  attr_accessible :attempts, :state, :url, :urldoc, :webhoook_id
  
  has_one :webhoook
  
end
