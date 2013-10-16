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
 
end
