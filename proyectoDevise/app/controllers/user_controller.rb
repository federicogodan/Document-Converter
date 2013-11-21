class UserController < ApplicationController
  def home
    cookies[:nickname] = ""     
  end
  
  def dashboard
     #us = User.find_by_nick(cookies[:nickname])            
     #doc = Document.new(document_number:1,name:"holaDoc",uploading:true)
     #doc.format = Format.find(8) #EL FORMATO ES TXT
     #us.save
     #doc.user = us              
     #doc.save
     #us.documents.push(doc)
     #us.save
     @user = User.find_by_nick(cookies[:nickname])
    #respond_with resource, :location => after_sign_in_path_for(resource)       
  end

  def used_storage
    @current_user = User.find_by_nick(cookies[:nickname])
    render :json => {used_storage: @current_user.used_storage, total_storage: @current_user.total_storage_assigned }
  end
end
  