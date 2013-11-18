class Api::FreeSpaceController < ApplicationController
  
  before_filter :restrict_access
  
  def read_api_key
    #api_key = request.headers["X-API-KEY"]
    api_key = params[:api_key] #if api_key.nil?
    api_key
  end
  
  def check_api_token(secret_key, string_to_convert, hash)
    hash_verification = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_key, string_to_convert)).strip
    puts "el hash verificador es:" + hash_verification
    hash == hash_verification
  end
  
  def restrict_access
    puts '***************ENTRO A restrict_access ***********************'
    api_key = read_api_key
    puts "La llave es:"
    puts api_key
    puts "El hash es:"
    hash = params[:hash]
    puts hash  
    user_access = User.find_by_api_key(api_key)
    if !user_access.nil? && !hash.nil?
      access_error = false
      @current_user = user_access
      puts "La secret key es:"
      puts user_access.secret_key
      puts formats
      puts "Antes de entrar a check api token"
      puts 'el string to convert [request.original_url] es: ' + request.original_url
      matches = check_api_token(user_access.secret_key, request.original_url, hash)
      puts 'El resultado de la comparacion fue'
      puts matches
      puts 'FIN restrict_access'
      puts 'antes de json'
    else
      access_error = true
    end
    puts 'antes de entrar a access_error'
    puts 'access_error'
    if access_error 
      puts 'ERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRROOOOOOOOOOOOOOORRRRRRRRRRRRRRRRRRR'
      render json: {:error => "401"}
    end
    puts 'despues de error'
  end
  
  def index
     puts '>'*50
     puts 'entro al index' 
     #free_space = @user.get_total_storage_assigned - @user.used_storage 
     free_space = @current_user.get_total_storage_assigned - @current_user.used_storage
     render :json => free_space 
  end
end