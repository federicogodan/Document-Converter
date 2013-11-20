class Api::FreeSpaceController < ApplicationController
  
  before_filter :restrict_access
  
  def read_api_key
    api_key = params[:api_key]
    api_key
  end
  
  def check_api_token(secret_key, string_to_convert, hash)
    hash_verification = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_key, string_to_convert)).strip
    hash == hash_verification
  end
  
  def restrict_access
    api_key = read_api_key
    hash = params[:hash]
    user_access = User.find_by_api_key(api_key)
    
    if !user_access.nil? && !hash.nil?
      @current_user = user_access
      parsed_request = request.original_url.split('?')[0]
      access_error = check_api_token(user_access.secret_key, parsed_request, hash)
    else
      access_error = false
    end
    if !access_error 
      render json: {:error => "401"}
    end
  end
  
  def index 
     free_space = @current_user.get_total_storage_assigned - @current_user.used_storage
     render :json => free_space 
  end
end