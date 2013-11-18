class Api::ConvertDocumentController < ApplicationController#ApiController

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
      access_error = check_api_token(user_access.secret_key, request.original_url, hash)
    else
      access_error = false
    end
    if !access_error 
      render json: {:error => "401"}
    end
  end
    
  def create
     if params[:document][:upload_method] == 'URL'
       @file_name =  File.basename(URI.parse(params[:document][:url]).path)
       temp_path = "./" + Time.now.to_s
       FileUtils.mkdir(temp_path)
       File.open(temp_path + '/' + @file_name, 'wb') do |fo|
          fo.write(open(params[:document][:url]).read)
       end
       @file_content = File.open(temp_path + "/" + @file_name)
       @f_size = @file_content.size if @file_content      
    else 
      @file_name = params[:document][:file].original_filename
      @file_content = params[:document][:file] 
      @f_size = @file_content.size if @file_content
    end

    has_extension = File.extname(@file_name).split('.')[1] if @file_name
    ext = has_extension.upcase if has_extension        
    origin_format = Format.find_by_name(ext) if ext
  
    destiny_format_name = params[:document][:destination_format]    
    destiny_format = Format.find_by_name(destiny_format_name) if destiny_format_name # != nil
      
    valid_parameters = true
    @doc_error = nil
    
    if (@file_name && @file_content && @f_size && origin_format && destiny_format && @current_user && 
       (@f_size <= @current_user.max_document_size) && ((@current_user.used_storage + @f_size) <= @current_user.total_storage_assigned))
      #Creating association between the user and the document uploaded. Also creating the converted document's object
  
      @document = Document.new(name:@file_name,expired:false,size:@f_size)
      @document.file = @file_content      
      

      @document.format = origin_format
      @document.user = @current_user
      @document.converted_document = ConvertedDocument.new
      @document.converted_document.set_to_converting
      @document.converted_document.format = destiny_format
    else
    
      #obtains the data error
      if (@f_size <= @current_user.max_document_size)
         @doc_error = "max_document_size"
      elsif (@current_user && ((@current_user.used_storage + @f_size) <= @current_user.total_storage_assigned))
         @doc_error = "total_storage_assigned"
      else
          @doc_error = "unprocessable_entity"
      end
      
      valid_parameters = false
    end
    
    if params[:document][:upload_method] == 'URL'
      FileUtils.rm_rf(temp_path)
    end
    
    respond_to do |f|
      if valid_parameters && @document.save && @document.converted_document.save
        f.json { render json: @document, status: :created }
      else
        f.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end
  
   def index
    ext = params[:extension]
    reg_filename = Format.find_by_name(ext)
    formats = []
    reg_filename.destinies.each do |f|
      formats.push(f.name)
    end
    render :json => formats
  end
end
