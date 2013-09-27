class RegisteredUser < ActiveRecord::Base
  validates_uniqueness_of :email
  attr_accessible :api_key, :documents_time_for_expiration, :email, :secret_key, :total_storage_assigned
end
