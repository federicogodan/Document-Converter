class User < ActiveRecord::Base
  before_validation :check_birthdate
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
  
  # A user has many documents to be converted.
  has_many :documents
  
  #A user has many converted documents too
  has_many :converted_documents, through: :documents
  
  #A user could have many webhooks to be alert for some completed conversion
  has_many :webhooks
  
  # Allow to login with a nick or email. 
  def self.find_for_database_authentication(conditions={})
    self.where("nick = ?", conditions[:email]).limit(1).first ||
    self.where("email = ?", conditions[:email]).limit(1).first
  end
  
  #checks that the birth_date be lesser than today.
  def check_birthdate
    if (self.birth_date != nil) and (self.birth_date > Date.today)
       errors.add(:user,"Birthdate is in the future.")
       false
    end
  end
end
