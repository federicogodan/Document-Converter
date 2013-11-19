class User::RegistrationController < Devise::RegistrationsController
  def new
    super
  end

  def create
    #set up profile_type manually
    puts sign_up_params[:profile_type] = "standard"
    #set the default values, read default values from file    
    default_values = eval(File.open('default_values.properties') {|f| f.read })
    #set the storage assigned
    sign_up_params[:total_storage_assigned] = default_values[:storage]
    #set the default documents time for expiration in seconds
    sign_up_params[:documents_time_for_expiration] = default_values[:documents_time_expiration]
    #set the max document size
    sign_up_params[:max_document_size] = default_values[:max_document_size]
    
    build_resource(sign_up_params)
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?       

        #respond_with resource, :location => after_sign_up_path_for(resource.is_a? User)
        cookies[:nickname] = resource.nick
        redirect_to '/user/dashboard'
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        
        expire_session_data_after_sign_in!

        #respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        redirect_to '/user/home'
      end
    else
      #catch error: email or nick already exists
      set_flash_message :notice, :log_error if is_navigational_format?
      clean_up_passwords resource
      #respond_with resource
      redirect_to '/user/home'
    end
  end

  def update
    super
  end
  
  def home
  end
end 
