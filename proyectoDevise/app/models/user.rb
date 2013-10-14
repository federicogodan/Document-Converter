class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:lockable

  #validates_uniqueness_of :nick
  validates :nick, presence: true, uniqueness: true, length: { minimum: 6 }

  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :name, :nick, :surname, :birth_date, :profile_type,
                  :api_key, :secret_key, :total_storage_assigned, :documents_time_for_expiration, :failed_attempts
  # attr_accessible :title, :body
  
  # Allow to login with a nick or email. 
  def self.find_for_database_authentication(conditions={})
    self.where("nick = ?", conditions[:email]).limit(1).first ||
    self.where("email = ?", conditions[:email]).limit(1).first
  end
end
