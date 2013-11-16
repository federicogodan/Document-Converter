class User < ActiveRecord::Base
  before_validation :check_birthdate
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         #,:lockable

  #validates_uniqueness_of :nick
  validates :nick, presence: true, uniqueness: true, length: { minimum: 6 }
  validates :api_key, uniqueness: true
  validates :secret_key, uniqueness: true
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, 
                  :remember_me, :name, :nick, :surname, :birth_date, :profile_type,
                  :api_key, :secret_key, :total_storage_assigned, :documents_time_for_expiration, 
                  :bandwidth_in_bytes_per_sec,:max_document_size, :limit_of_conversions
  
  # A user has many documents to be converted.
  has_many :documents
  
  #A user has many converted documents too
  has_many :converted_documents, through: :documents
  
  #A user could have many webhooks to be alert for some completed conversion

  has_many :webhoooks
  
  
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
  
  #function that return the used storage for one user
  def used_storage
    used_size = 0
    self.documents.each do |doc|
      cd = (ConvertedDocument.find_by_document_id(doc.id)) if !doc.expired
      used_size = cd.size if !cd.nil?
    end
    used_size
  end
  
  #function that throw the url of the converted documento through each webhook json={:action => 'ConvertedDocument', :data => urldoc}
  def alertallwebhooks( urldoc )
    self.webhoooks.each do |wh|
       wh.throwebhook( urldoc )  
    end  
  end 

  def percentage_of_converted_document
    documents = Document.where('user_id = ?', self.id)
    total_document = documents.count
    total_conv_doc = 0
    documents.each do |td|
      if !(ConvertedDocument.find_by_document_id(documents)).nil?
        total_conv_doc += 1
      end
    end
    porcentage = 100
    porcentage = total_conv_doc*100/total_document if total_conv_doc > 0
    
    porcentage
  end
  
  def cant_converted_document
    cant = 0
    self.documents.each do |doc|
      if !(ConvertedDocument.find_by_document_id(documents)).nil?
        cant += 1
      end
    end
    cant
  end
  
  def average_time_to_convert
    total_time = 0
    conversions = 0
    self.documents.each do |doc|
      total_time += doc.time_of_conversion
      if doc.time_of_conversion > 0
        conversions += 1
      end
    end
    average = 0
    average = total_time/conversions if conversions > 0
    average.round(2)
  end

  before_create :create_api_keys

  #method for create the api keys
  def create_api_keys
    #creates the public key
    begin
      token = SecureRandom.urlsafe_base64(nil, false)
    end until !User.exists?(api_key: token)
    self.api_key = token
    #creates the secret key
    begin
      token = SecureRandom.urlsafe_base64(nil, false)
    end until !User.exists?(api_key: token)
    self.secret_key = token
  end

end