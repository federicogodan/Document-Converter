require 'spec_helper'

describe Format do
  
  it 'valid' do
    f = Format.new(name: "pepe")
    f.valid?.should == true
  end
  
  it 'uniquenss name' do
    f = Format.new(name:"pdf")
    f.save
    
    f2 = Format.new(name:"pdf")
    f2.valid?.should == false
    
  end
  
  it 'nil name' do
    f = Format.new()
    f.valid?.should == false
  end
  
  it 'lot of asociations' do
      f = Format.new(name:"hola1")
      f2 = Format.new(name:"hola2")
      f2.save
      f3 = Format.new(name:"hola3")
      f3.save
      
      f.destinies.push(f2)
      f.destinies.push(f3)      
      f.save 
      
      f = Format.find_by_name('hola1')
      f.destinies.include?(f2).should be_true
      f.destinies.include?(f3).should be_true
  end
 
end
