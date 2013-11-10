class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  def total_used_storage
    total_storage = 0;
    User.each do |u|
      total_storage += u.used_storage
    end
    total_storage
  end
  
  def total_average_time_to_convert
    total_average = 0
    User.each do |u|
      total_average += u.average_time_to_convert
    end
    total_average = total_average/User.count
  end
  
  def total_percentage_of_converted_document
    total_porcentage = 0
    User.each do |u|
      total_porcentage += u.percentage_of_converted_document
    end
    total_porcentage = total_porcentage/User.count
  end
end
