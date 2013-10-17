require "spec_helper"

describe Document do
  
#"document_number"
#"creation_date"
#"name"
#"uploading"
#"original_extension"
#"created_at"
#"updated_at"
# "user_id"
  
  it 'create a document' do
    #add_one_user
    doc = Document.new(document_number:1, creation_date:Date.current, name:"documento1",
      original_extension:"pdf", user_id:14)
    doc.valid?.should == true
  end
  
  it 'Uniqueness document_number for a user id' do
    #add_one_user
    usr = User.new(email:"user1@gmail.com", nick:"usuario1", password:"12345678")
    usr.save
      
    doc1 = Document.new(document_number:1, creation_date:Date.current, name:"documento1",
      original_extension:"pdf")
    doc1.user = usr 
    doc1.save
    
    doc2 = Document.new(document_number:1, creation_date:Date.current, name:"documento2",
      original_extension:"pdf")
    doc2.user = usr  
    doc2.valid?.should == false
  end
  
  #la clave de el modelo es el user_id y document_number, por lo tanto dos documentos pueden
  #tener el mismo nombre.
  it 'Uniqueness name' do
    add_one_user
    doc1 = Document.new(document_number:1, creation_date:Date.current, name:"documento1",
      original_extension:"pdf", user_id:1)
    doc1.save
    
    doc2 = Document.new(document_number:2, creation_date:Date.current, name:"documento1",
      original_extension:"pdf", user_id:1)
    doc2.valid?.should == true
  end
  
  it 'No document_number' do
    add_one_user
    doc = Document.new(name:"documento1", original_extension:"pdf", user_id:1)
    doc.save.should == false
  end
  
  it 'No user_id' do
    add_one_user
    doc = Document.new(document_number:1, name:"documento1", original_extension:"pdf")
    doc.save.should == false
  end
  
  it 'No user_id and document_number' do
    add_one_user
    doc = Document.new(name:"documento1", original_extension:"pdf")
    doc.save.should == false
  end
  
end