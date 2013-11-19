class Whsent < ActiveRecord::Base
  attr_accessible :attempts, :state, :url, :webhoook_id
  has_one :webhoook
end
