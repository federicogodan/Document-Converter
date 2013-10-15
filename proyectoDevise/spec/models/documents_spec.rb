require "spec_helper"

describe Document do
  
<<<<<<< HEAD
#"document_number"
#"creation_date"
#"name"
#"uploading"
#"original_extension"
#"created_at"
#"updated_at"
# "user_id"
  
  it 'create a document' do
    add_one_user
    doc = Documents.new(document_number:1, creation_date:Date.current, name:"documento1",
      original_extension:"pdf", user_id:1)
    doc.save_failure == false
=======
  it 'user_id document_number uniqueness' do
    doc = Document.new()
    doc.user = register_user
    doc.document_number = 1
    doc.save
    
    doc2 = Document.new()
    doc2.user = register_user
    doc2.document_number = 1
    doc2.valid?.should_not be_true

>>>>>>> 0beeab2eaf290c28d1ea3894b65f570105c629b9
  end

end