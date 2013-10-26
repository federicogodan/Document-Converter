require "spec_helper"

describe Document do
  
  it 'create a document' do
    u = register_user
    f = add_format
    doc = Document.new(user_id:u.id, name:"documento1", format:f)
    
    doc.valid?.should == true
  end
  
  it 'Uniqueness document_number for a user id' do
    
    u = register_user
    f = add_format
      
    doc1 = Document.new(document_number:1, name:"documento1")
    doc1.user = u
    doc1.format = f 
    doc1.save
    
    doc2 = Document.new(document_number:1, name:"documento2")
    doc2.user = u
    doc2.format = f
    doc2.valid?.should == false
  end
  
  it 'No document_number' do
    doc = Document.new(name:"documento1")
    doc.user = register_user
    doc.format = add_format
    doc.save.should == false
  end
  
  it 'No user_id' do
    doc = Document.new(document_number:1, name:"documento1")
    doc.format = add_format
    doc.save.should == false
  end
  
  it 'No user_id and document_number' do
    doc = Document.new(name:"documento1")
    doc.save.should == false
  end
  
end