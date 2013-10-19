require 'spec_helper'

describe Format do
  
  context 'format:' do
    it 'name uniqueness' do
      f = Format.new(name: 'hola')
      f.save
      
      f2 = Format.new(name: 'hola')
      f2.valid?.should == false
    end
    
    it 'lot of asociations' do
      f = Format.new(name: 'hola1')
      f2 = Format.new(name: 'hola2')
      f3 = Format.new(name: 'hola3')
      
      f.destinies.push(f2)
      #f.detiny = f3
      
      f.save 
    end
  end
  
end
