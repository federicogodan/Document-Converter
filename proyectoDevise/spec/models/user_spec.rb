require 'spec_helper'

describe User do
  it 'uniqueness email' do
    us1 = User.new(email:"hellohowareyou@gmail.com",nick:"hellohowareyou",password:"hellohowareyou")
    us1.save
    
    us2 = User.new(email:"hellohowareyou@gmail.com",nick:"anotherthing",password:"anotherthing")
    us2.valid?.should == false
  end
  
  it 'uniqueness nick' do
    us1 = User.new(email:"us1@gmail.com",nick:"nickname1",password:"hellohowareyou")
    us1.save
    
    us2 = User.new(email:"anotheruser@gmail.com",nick:"nickname1",password:"anotherthing")
    us2.valid?.should == false
  end
  
  it 'valid password' do
    us1 = User.new(email:"us1@gmail.com",nick:"nickname1",password:"MoreThanEight")
    us1.save
    
    us2 = User.new(email:"us2@gmail.com",nick:"nickname2",password:"Less8")
    us2.valid?.should == false
  end
  
  it 'valid nick' do
    us1 = User.new(email:"us1@gmail.com",nick:"less6",password:"MoreThanEight")
    us1.valid?.should == false
    
  end
  
  it 'valid birthdate' do
    us1 = User.new(email:"us1@gmail.com",nick:"nickname1",password:"MoreThanEight",birth_date:Date.current)
    us1.save
  
    us2 = User.new(email:"us2@gmail.com",nick:"nickname2",password:"MoreThanEight",birth_date:Date.tomorrow)
    us1.valid?.should == false
  end
  
  it 'valid email format' do
    us1 = User.new(email:"badFormatEmail",nick:"nickname1",password:"MoreThanEight",birth_date:Date.current)
    us1.valid?.should == false
    
  end
  
  it 'password equal password_confirmation' do
    us1 = User.new(email:"us1@gmail.com",nick:"nickname1",password:"MoreThanEight",password_confirmation:"OtherThing")
    us1.valid?.should ==false
  end
  
  it 'password equal password_confirmation less 8' do  
    us1 = User.new(email:"us1@gmail.com",nick:"nickname1",password:"less8",password_confirmation:"less8")
    us1.valid?.should == false
  end
  
  it 'combination bad email, less 6 nick' do
    us1 = User.new(email:"badFormatEmail",nick:"less6",password:"less8",password_confirmation:"OtherThing")
    us1.valid?.should == false
  end
  
  it 'combination less 6 nick, less 8 password' do   
    us1 = User.new(email:"us1@gmail.com",nick:"less6",password:"less8",password_confirmation:"OtherThing")
    us1.valid?.should == false
  end  
  
  it 'combination bad email, less 8 password_confirmation' do
    us1 = User.new(email:"badFormatEmail",nick:"nickname1",password:"MoreThanEight",password_confirmation:"less8")
    us1.valid?.should == false
  end
  
  it 'combination less 6 nick, password != password_confirmation' do
    us1 = User.new(email:"us1@gmail.com",nick:"less6",password:"MoreThanEight",password_confirmation:"OtherThing")
    us1.valid?.should == false
  end
  
  it 'combination bad format email, password != password_confirmation' do 
    us1 = User.new(email:"badFormatEmail",nick:"nickname1",password:"MoreThanEight",password_confirmation:"OtherThing")
    us1.valid?.should == false
  end
 
end