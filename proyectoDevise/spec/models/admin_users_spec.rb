require 'spec_helper'

describe AdminUser do

  it 'creat a valid admin' do
    adm1 = AdminUser.new(email:"admin1@gmail.com", password:"12345678")
    adm1.valid?.should == true
  end

  it 'Uniqueness email' do
    adm1 = AdminUser.new(email:"admin1@gmail.com", password:"12345678")
    adm1.save
    
    adm2 = AdminUser.new(email:"admin1@gmail.com", password:"123456789")
    adm2.valid?.should == false
  end
  
  it 'Bad format email: with out .com' do
    adm2 = AdminUser.new(email:"admin1@gmail", password:"123456789")
    adm2.valid?.should == false
  end
  
  it 'Bad format email: with out @' do
    adm2 = AdminUser.new(email:"admin1gmail.com", password:"123456789")
    adm2.valid?.should == false
  end
  
  it 'No password' do
    adm2 = AdminUser.new(email:"admin1gmail.com", )
    adm2.valid?.should == false
  end
  
  it 'No email' do
    adm2 = AdminUser.new(password:"12345678", )
    adm2.valid?.should == false
  end
  
  it 'Invalid password_confirmation' do
    adm1 = AdminUser.new(email:"admin1@gmail.com", password:"12345678", password_confirmation:"123456789")
    adm1.valid?.should == false
  end
end
