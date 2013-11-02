class User::SessionsController < Devise::SessionsController
def new
  self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
     
    #Actualize the variable invalid_user to make appear the alert text
    @invalid_user = 1
     
    #respond_with resource, :location => log_in_invalid(resource)
    redirect_to "/user/home"
end
def create
  self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    
    #Its a valid user, so the invalid_user variable is actualize
    @invalid_user = 0       
    
    cookies[:nickname] = resource.nick
    @current_user = User.find_by_nick(cookies[:nickname])
    #respond_with resource, :location => after_sign_in_path_for(resource)
    redirect_to "/user/new_file"
end
def destroy
  super
end

end
