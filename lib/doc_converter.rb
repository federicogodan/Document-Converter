require 'base64'
require 'openssl'
require 'rest_client'
require 'rubygems'
require 'yaml'

class DocConverter
  include Base64
  include OpenSSL
  include RestClient
  
  # Configuration defaults
  @config = {
             :server_adress => "http://documentconverter.elasticbeanstalk.com",
             :api_key => 'my_api_key',
             :secret_key => 'my_secret_key'
            }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)

    begin
      config = YAML::load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @config
  end
  
  
  def self.convert_document(file_path, destiny_format, upload_method)
   
   hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), config[:secret_key], config[:server_adress]+'/api/convert_document/')).strip
   
   if upload_method == 'FILE'
    RestClient.post config[:server_adress]+'/api/convert_document/', :document => { :file => File.new(file_path), :destination_format => destiny_format, 
                              :upload_method => upload_method }, :api_key => config[:api_key], :hash => hash, :content_type => :json, :accept => :json  
   else
    RestClient.post config[:server_adress]+'/api/convert_document/', :document => { :url => file_path, :destination_format => destiny_format, 
                              :upload_method => upload_method }, :api_key => config[:api_key], :hash => hash, :content_type => :json, :accept => :json
   end
  end

  def self.get_formats(ext)
    hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), config[:secret_key], config[:server_adress]+'/api/convert_document/')).strip
    RestClient.get config[:server_adress]+'/api/convert_document/', {:params => {:extension => ext, :api_key => config[:api_key], :hash => hash}, 
                                                                  :content_type => :json, :accept => :json}
  end
  
  def self.get_free_space
    hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), config[:secret_key], config[:server_adress]+'/api/free_space/')).strip
    RestClient.get config[:server_adress]+'/api/free_space/', {:params => {:api_key => config[:api_key], :hash => hash}, :content_type => :json, :accept => :json}
  end
  
end
