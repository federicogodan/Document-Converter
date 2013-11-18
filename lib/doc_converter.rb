require 'rubygems'
require 'rest_client'
require 'base64'
require 'openssl'

class DocConverter
  include RestClient
  attr_accessible :api_key, :secret_key
  
  def self.set_keys
    api_key = 'vo9H_h3YS2VxfHd8SlveNw' #userexample50 ARREGLAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    secret_key = '5-mvibcPsUx1NBMEoQhobQ' #userexample50 ARREGLAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  end
  
  def self.convert_document(file_path, destiny_format, upload_method)
   
   hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_key, 'http://localhost:3000/api/convert_document')).strip
   
   if upload_method == 'FILE'
    RestClient.post 'http://localhost:3000/api/convert_document', :document => { :file => File.new(file_path), :destination_format => destiny_format, 
                              :upload_method => upload_method }, :api_key => api_key, :hash => hash, :content_type => :json, :accept => :json  
   else
    RestClient.post 'http://localhost:3000/api/convert_document', :document => { :url => file_path, :destination_format => destiny_format, 
                              :upload_method => upload_method }, :api_key => api_key, :hash => hash, :content_type => :json, :accept => :json
  end

  def self.get_formats(ext)
    hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_key, 'http://localhost:3000/api/convert_document')).strip
    RestClient.get 'http://localhost:3000/api/convert_document', {:params => {:extension => ext, :api_key => api_key, :hash => hash}, 
                                                                  :content_type => :json, :accept => :json}
  end
  
  def self.get_free_space
    RestClient.get 'http://localhost:3000/api/free_space', :content_type => :json, :accept => :json
  end
  
end


#MARCOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOoo
#require 'rubygems'
#require 'rest_client'
#require 'yaml'

#class DocConverter
#  include RestClient

  # Configuration defaults
#  @config = {
#              :server_adress => "http://localhost:3000"
#            }

#  @valid_config_keys = @config.keys

  # Configure through hash
#  def self.configure(opts = {})
#    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
#  end

  # Configure through yaml file
#  def self.configure_with(path_to_yaml_file)
#    begin
#      config = YAML::load(IO.read(path_to_yaml_file))
#    rescue Errno::ENOENT
#      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
#    rescue Psych::SyntaxError
#      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
#    end

#    configure(config)
#  end

#  def self.config
#    @config
#  end
  
  #def self.set_keys(api_key, secret_key)
  #  @api_key = api_key
  #  @secret_key = secret_key
  #end
  
#  def self.convert_document(file_path, format)
#   RestClient.post config[:server_adress]+'/documents', :document => { :file => File.new(file_path), :destination_format => format}, :content_type => :json, :accept => :json
#  end

#  def self.get_formats(ext)
#    RestClient.get config[:server_adress]+'/convert/get_formats', {:params => {:extension => ext}}, :content_type => :json, :accept => :json
#  end
  
#  def self.get_free_space
#    puts config[:server_adress]+'/user/get_free_space'
#    RestClient.get config[:server_adress]+'/user/get_free_space', :content_type => :json, :accept => :json
#  end
  
#end


