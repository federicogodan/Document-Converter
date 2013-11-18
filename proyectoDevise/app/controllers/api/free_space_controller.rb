class Api::FreeSpaceController < ApplicationController
  def index
     #@user = User.find_by_nick(cookies[:nickname]) 
     @user = User.find_by_nick('userexample1')#CAMBIAR PARA API KEY!!!!!!!!!!!!!!!!!!!!!! 
     free_space = @user.get_total_storage_assigned - @user.used_storage 
     render :json => free_space 
  end
end