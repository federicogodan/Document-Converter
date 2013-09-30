class RegisteredUser < ActiveRecord::Base
  validates_uniqueness_of :user_id
  attr_accessible :api_key, :documents_time_for_expiration, :user_id, :secret_key, :total_storage_assigned
end
