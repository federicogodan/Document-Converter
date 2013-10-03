require "spec_helper"

describe Document do
  
  it 'uniqueness user_id document_number' do
    doc = Document.new()
    doc.user = User.first # ???
    doc.user_id = User.first.id # ???
    doc.document_number = 1
    doc.save
    
    doc2 = Document.new()
    doc2.user = User.first # ???
    doc2.user_id = User.first.id # ???
    doc2.document_number = 1
    doc2.valid?.should_not be_true
    
  end

end