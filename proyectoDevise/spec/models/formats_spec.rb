require 'spec_helper'

describe Formats do
  
  context 'format:' do
    it 'name uniqueness' do
      f = Format.new(name: 'hola')
      f.save
      
      f2 = Format.new(name: 'hola')
      f2.valid?.should == true
    end
  end
  
end
