require 'spec_helper'

describe User do
  
  it 'with valid params' do
    user = User.new(email:"test@test.com", nick:"testtest", password:"holamundo", password_confirmation:"holamundo")
    user.valid?.should == true
    
  end
  
  it 'invalid password' do
    user = User.new(email:"test@test.com", nick:"test", password:"1")
    user.valid?.should == false
  end
  
  it 'invalid email' do
    user = User.new(email:"", nick:"test", password:"holamundo")
    user.valid?.should == false
  end
  
  it 'invalid nick' do
    user = User.new(email:"test@test.com", nick:"", password:"holamundo")
    user.valid?.should == false
    
    # FALLA! Falta validar que el nick sea oblgatorio
  end
  
  it 'nick uniqueness' do
    user = User.new(email:"test@test.com", nick:"test", password:"holamundo")
    user.save
    
    user2 = User.new(email:"test2@test.com", nick:"test", password:"holamundo")
    user2.valid?.should == false
  end
  
  it 'email uniqueness' do
    user = User.new(email:"test@test.com", nick:"test", password:"holamundo")
    user.save
    
    user2 = User.new(email:"test@test.com", nick:"test2", password:"holamundo")
    user2.valid?.should == false
  end
  
  
  
end
