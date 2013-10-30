class UserController < ApplicationController
  def home
    cookies[:nickname] = ""     
  end
  
  def new_file
    #Association between user and document
     #us = User.find_by_nick(cookies[:nickname])            
     #doc = Document.new(document_number:1,name:"holaDoc",uploading:true)
     #doc.format = Format.find(8) #EL FORMATO ES TXT
     #us.save
     #doc.user = us              
     #doc.save
     #us.documents.push(doc)
     #us.save                                        
  end
end
  