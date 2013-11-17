require 'rubygems'
require 'rest_client'

class DocConverter
  include RestClient
  
  #def self.set_keys(api_key, secret_key)
  #  @api_key = api_key
  #  @secret_key = secret_key
  #end
  
  def self.convert_document(file_path, format)
   #RestClient.post 'http://documentconverter-env.elasticbeanstalk.com:80/api/', :document => { :file => File.new(file_path), :destination_format => format}, :X-API-KEY => @api_key, :X-URL-HASH => @secret_key
   RestClient.post 'http://documentconverter-env.elasticbeanstalk.com:80/documents', :document => { :file => File.new(file_path), :destination_format => format}, :content_type => :json, :accept => :json
  end

  def self.get_formats(ext)
    RestClient.get 'http://localhost:3000/convert/get_formats', {:params => {:extension => ext}}, :content_type => :json, :accept => :json
  end
  
  def self.get_free_space
    RestClient.get 'http://localhost:3000/user/get_free_space', :content_type => :json, :accept => :json
  end
  
end
