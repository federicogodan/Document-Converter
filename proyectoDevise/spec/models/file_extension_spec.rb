require 'spec_helper'

describe FileExtension do
  it 'validates uniqueness of extension and can_be_converted' do
    add_format
    
    fe1 = FileExtension.new(extension:1,can_be_converted_to:2)
    fe1.save
    
    fe2 = FileExtension.new(extension:1,can_be_converted_to:2)
    fe2.valid?.should == false
  end
  
  it 'one extension, many can_be_converted' do
    add_format
    
    fe1 = FileExtension.new(extension:1,can_be_converted_to:1)    
    fe2 = FileExtension.new(extension:1,can_be_converted_to:2)
    fe3 = FileExtension.new(extension:1,can_be_converted_to:3)
    fe4 = FileExtension.new(extension:1,can_be_converted_to:4)
    
    fe1.save
    fe2.save
    fe3.save
    fe4.valid?.should == true
  end
  
  it 'many extension, one can_be_converted' do
    add_format
    
    fe1 = FileExtension.new(extension:1,can_be_converted_to:1)    
    fe2 = FileExtension.new(extension:2,can_be_converted_to:1)
    fe3 = FileExtension.new(extension:3,can_be_converted_to:1)
    fe4 = FileExtension.new(extension:4,can_be_converted_to:1)
    
    fe1.save
    fe2.save
    fe3.save
    fe4.valid?.should == true
  
  end
end
