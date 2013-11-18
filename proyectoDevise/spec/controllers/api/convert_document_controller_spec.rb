require 'spec_helper'


RSpec.configure do |c|
  c.use_transactional_examples = false  #makes that the entities created in every "it block" maintains it's data in the database 
end

describe Api::ConvertDocumentController do
  it 'validates max_document_size located in user variables' do
    #Creating user pepe100
    us = User.new(nick:"pepe100", email:"pepe100@gmail.com",name:"pepe",surname:"trueno",password:"pepepepe",password_confirmation:"pepepepe",
                  profile_type:"standard",total_storage_assigned:10000,max_document_size:3500)
    us.save
    
    
    #Creating valid document 1
    doc1 = Document.new(name:"doc1",expired:false,size:50000)
    doc1.format = Format.find(1)
    doc1.user = us
    doc1.converted_document = ConvertedDocument.new()
    doc1.converted_document.format = doc1.format.destinies.first
    doc1.converted_document.set_to_converting    
    doc1.converted_document.update_converted_document("ok","www.sitio1.com",3000)
    doc1.save
    us.documents.push(doc1)
    us.save
    
    #Creating FAILED document 2 (the message of update_converted_document is "fail")
    doc2 = Document.new(name:"doc2",expired:false,size:80000)
    doc2.format = Format.find(2)
    doc2.user = us
    doc2.converted_document = ConvertedDocument.new()
    doc2.converted_document.format = doc2.format.destinies.first
    doc2.converted_document.set_to_converting    
    doc2.converted_document.update_converted_document("fail","www.sitio2.com",1333)
    doc2.save
    us.documents.push(doc2)
    us.save
    
    #Creating valid document 3
    doc3 = Document.new(name:"doc3",expired:false,size:60000)
    doc3.format = Format.find(3)
    doc3.user = us
    doc3.converted_document = ConvertedDocument.new()
    doc3.converted_document.format = doc3.format.destinies.first
    doc3.converted_document.set_to_converting    
    doc3.converted_document.update_converted_document("ok","www.sitio3.com",2005)
    doc3.save
    us.documents.push(doc3)
    us.save
    
    #Creating valid document 4
    doc4 = Document.new(name:"doc4",expired:false,size:80000)
    doc4.format = Format.find(3)
    doc4.user = us
    doc4.converted_document = ConvertedDocument.new()
    doc4.converted_document.format = doc4.format.destinies.first
    doc4.converted_document.set_to_converting    
    doc4.converted_document.update_converted_document("ok","www.sitio4.com",1000)
    doc4.save
    us.documents.push(doc4)
    us.save
    
    #Creating INVALID document 5 with the controller
    #TODO SEGUIIIIIIIIIIIIIIRRRRRRRRRRRRRR
    expect{
      post :create, {name: "el pibe 10"}
      
    }
    
    #doc5 = Document.new(name:"doc5",expired:false,size:4000) #exceeded of the max_document_size's value
    #doc5.format = Format.find(3)
    #doc5.user = us
    #doc5.converted_document = ConvertedDocument.new()
    #doc5.converted_document.format = doc5.format.destinies.first
    #doc5.converted_document.set_to_converting    
    #doc5.converted_document.update_converted_document("ok","www.sitio5.com",50000) 
    #doc5.save
    #us.documents.push(doc5)
    #us.save
  end
end
