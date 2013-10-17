require 'spec_helper'

describe Format do
  
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
      f = Format.new(name: 'hola1')
      f2 = Format.new(name: 'hola2')
      f3 = Format.new(name: 'hola3')
      
      #f.destiny = f2
      f.destinies.push(f2)
      #f.detiny = f3
      
      f.save 
  end
 
end
