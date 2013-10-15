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
    add_one_user
    doc = Documents.new(document_number:1, creation_date:Date.current, name:"documento1",
      original_extension:"pdf", user_id:1)
    doc.save_failure == false
  end

end