require "spec_helper"

describe Document do
  
  it 'user_id document_number uniqueness' do
    doc = Document.new()
    doc.user = register_user
    doc.document_number = 1
    doc.save
    
    doc2 = Document.new()
    doc2.user = register_user
    doc2.document_number = 1
    doc2.valid?.should_not be_true

  end

end