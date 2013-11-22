class UserController < ApplicationController
  def home
    if !@user.nil?
      render "user/dashboard"
    end     
  end
  
  def dashboard
     @user = User.find_by_nick(cookies[:nickname])   
  end

  def used_storage
    @current_user = User.find_by_nick(cookies[:nickname])
    render :json => {used_storage: @current_user.used_storage, total_storage: @current_user.total_storage_assigned }
  end
end