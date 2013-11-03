class User < ActiveRecord::Base
  before_validation :check_birthdate
  
  after_save :insert_counter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         #,:lockable

  #validates_uniqueness_of :nick
  validates :nick, presence: true, uniqueness: true, length: { minimum: 6 }

  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :name, :nick, :surname, :birth_date, :profile_type,
                  :api_key, :secret_key, :total_storage_assigned, :documents_time_for_expiration
  
  # A user has many documents to be converted.
  has_many :documents
  
  #A user has many converted documents too
  has_many :converted_documents, through: :documents
  
  #A user could have many webhooks to be alert for some completed conversion
  has_many :webhoooks
  
  #A user has a counter for his/her documents (it's local for every user)
  has_one :users_counters
  
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
  
  #function that inserts a row on the table users_counters, containing the default documents'counter of a user(counter = 1)
  def insert_counter
    uc = UsersCounter.new(counter:1)
    uc.user = self
    uc.save
  end
  
  #function that return the used storage for one user
  def used_storage
    used_size = 0
    self.documents.each do |doc|
      used_size += (ConvertedDocument.find_by_document_id(doc.id)).size if !doc.expired
    end    
    used_size
  end
end