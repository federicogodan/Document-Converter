require "spec_helper"

describe Document do
  it 'create a document' do
    u = register_user
    f = add_format
    doc = Document.new(name:"documento1", file: "prueba", name: "doc_prueba", size: 10)
    doc.user = u
    doc.format = f
  end
  
  it 'No user' do
    doc = Document.new(name:"documento1", file: "prueba", name: "doc_prueba", size: 10)
    doc.format = add_format
    doc.save.should == false
  end
  
  it 'no format' do
    doc = Document.new(name:"documento1", file: "prueba", name: "doc_prueba", size: 10)
    doc.user = register_user
    doc.save.should == false
  end
end