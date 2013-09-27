class RegisteredUser < ActiveRecord::Base
  attr_accessible :api_key, :documents_time_for_expiration, :email, :secret_key, :total_storage_assigned
end
