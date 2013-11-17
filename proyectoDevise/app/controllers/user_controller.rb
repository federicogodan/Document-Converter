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
   def get_free_space 
     #@user = User.find_by_nick(cookies[:nickname]) 
     @user = User.find_by_nick('userexample1')#CAMBIAR PARA API KEY!!!!!!!!!!!!!!!!!!!!!! 
     free_space = @user.get_total_storage_assigned - @user.used_storage 
     render :json => free_space 
   end
end
  