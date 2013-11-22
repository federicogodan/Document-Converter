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
      parsed_request = request.original_url.split('?')[0]
      access_error = check_api_token(user_access.secret_key, parsed_request, hash)
    else
      access_error = false
    end
    if !access_error 
      render json: {:error => "401"}
    end
  end
    
    
  def create            
    #initializing variables
    valid_parameters = true 
    is_valid_file_status = true    
    @file_name = nil
    @file_content = nil
    @f_size = nil    
    @doc_error = ''
    @aux_variable_file = params[:document][:file]    

    #checking method of upload(Remote or local file)           
    #REMOTE METHOD                                 
    #checks that the url of the file be a valid one.(in ASCII format)
    if params[:document][:upload_method] == 'URL' && !@aux_variable_file.nil? && @aux_variable_file.gsub!(/\P{ASCII}/, '').nil?
      begin
         @file_name =  File.basename(URI.parse(@aux_variable_file).path)
         temp_path = "./tmp/" + Time.now.to_s
         FileUtils.mkdir(temp_path)
         File.open(temp_path + '/' + @file_name, 'wb') do |fo|
             fo.write(open(@aux_variable_file).read)
         end
         @file_content = File.open(temp_path + "/" + @file_name)
         @f_size = @file_content.size if @file_content
      rescue #Catch an exception, if File class fail
         is_valid_file_status = false
      end           
    #LOCAL METHOD
    #checks that the  path and the name of the file be a valid one.(in ASCII format)       
    elsif params[:document][:upload_method] != 'URL' && !@aux_variable_file.nil? && @aux_variable_file!="" && @aux_variable_file.path.gsub!(/\P{ASCII}/, '').nil? && @aux_variable_file.original_filename.gsub!(/\P{ASCII}/, '').nil?
        @file_name = params[:document][:file].original_filename
        @file_content = params[:document][:file] 
        @f_size = @file_content.size if @file_content
    end                        
    

    #auxiliary variables
    name_plus_extension = File.extname(@file_name) if !@file_name.nil?        
    has_extension = name_plus_extension.split('.')[1] if (!name_plus_extension.nil? && (name_plus_extension.split('.').count > 1))
    ext = has_extension.upcase if !has_extension.nil?        
    @origin_format = Format.find_by_name(ext) if !ext.nil?
    destiny_format_name = params[:document][:destination_format]    
    @destiny_format = Format.find_by_name(destiny_format_name) if !destiny_format_name.nil? 
    
             
    # Previous checks to prevent null values and variable controls
    if (is_valid_file_status && !@file_name.nil? && !@file_content.nil? && !@f_size.nil? && !@origin_format.nil? && !@destiny_format.nil? && 
      @origin_format.destinies.include?(@destiny_format) && !@current_user.nil? && !@current_user.max_document_size.nil?  && 
      (@f_size <= @current_user.max_document_size) && !@current_user.total_storage_assigned.nil? && 
      ((@current_user.used_storage + @f_size) <= @current_user.total_storage_assigned))
      
      #Creating association between the user and the document uploaded. Also creating the converted document's object 
      @document = Document.new(name:@file_name,expired:false,size:@f_size)
      @document.file = @file_content      
      @document.format = @origin_format
      @document.user = @current_user
      @document.converted_document = ConvertedDocument.new
      @document.converted_document.set_to_converting
      @document.converted_document.format = @destiny_format
    else
      # obtains the data error           
      if (@current_user.nil?)
         @doc_error = 'Session error: The session has expired. Please sign in again'         
      elsif (@current_user.max_document_size.nil? || @current_user.total_storage_assigned.nil?)
         @doc_error = 'Null variables in the database. Please contact with the technical\'s service'
      elsif (@file_name.nil?)
         @doc_error = 'File error: Can\'t obtain the route or name of the file (please use ASCII characters)' 
      elsif (@file_content.nil?)
         @doc_error = 'File error: Can\'t read the content of the file'
      elsif (@f_size.nil?)
         @doc_error = 'File error: Can\'t obtain the file\'s size'     
      elsif (!is_valid_file_status)
         @doc_error = 'File error: There was an error with the uploading. Please try again'
      elsif (has_extension.nil?)
         @doc_error = 'Format error: Can\'t obtain the File\'s extension'
      elsif (@origin_format.nil?)
         @doc_error = 'Format error: The format of the file is not a valid format for this version of DocumentConverted.'         
      elsif (@destiny_format.nil?)      
         @doc_error = 'Format error: Can\'t obtain the destiny format'
      elsif (!@origin_format.destinies.include?(@destiny_format))
         @doc_error = 'Format error: The format destination is not valid for the format\'s file'                   
      elsif (@f_size > @current_user.max_document_size)
         @doc_error = 'The uploaded file\'s size exceeds the maximum document\'s size permitted for this user'#"max_document_size"
      elsif ((@current_user.used_storage + @f_size) > @current_user.total_storage_assigned)
         @doc_error = 'The total storage\'s space permitted for this user is exceeded with the uploaded file\'s size'#"total_storage_assigned"
      else
          @doc_error = 'Unprocessable entity. Please contact with the technical\'s service'#"unprocessable_entity"
      end

      valid_parameters = false    
    end  
    
    if (valid_parameters && !@document.nil? && @document.save && 
       !@document.converted_document.nil? && @document.converted_document.save)          
      @doc_error = ''      #There was no error
    elsif valid_parameters #It means that the error is in @document.save or @document.converted_document.save    
      @doc_error = 'File error: Couldn\'t save the file in the database. Please try again later'
    end
          
    FileUtils.rm_rf(temp_path) if params[:document][:upload_method] == 'URL' &&  !temp_path.nil? #removing temp_file
    
    render json: @doc_error  
  end
  
  def index
    ext = params[:extension]
    reg_filename = Format.find_by_name(ext)
    formats = []
    puts ">"*50
    puts ext
    reg_filename.destinies.each do |f|
      formats.push(f.name)
    end
    
    render :json => formats
  end

end