class User::RegistrationController < Devise::RegistrationsController
  def new
    super
  end

  def create
    #set up profile_tyme manually
    puts sign_up_params[:profile_type] = "standar"
    build_resource(sign_up_params)
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
          
        #respond_with resource, :location => after_sign_up_path_for(resource.is_a? User)
        render 'user/new_file'
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        
        expire_session_data_after_sign_in!
        #respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        render 'user/home'
      end
    else
      #catch error: email or nick already exists
      set_flash_message :notice, :log_error if is_navigational_format?
      clean_up_passwords resource
      #respond_with resource
      render 'user/home'
    end
  end

  def update
    super
  end
  
  def home
  end
end 