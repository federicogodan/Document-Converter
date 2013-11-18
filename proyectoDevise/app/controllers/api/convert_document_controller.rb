class Api::ConvertDocumentController < ApplicationController#ApiController
    
  def create
    
    puts "$"*50
    puts params
    
    #RestClient.post 'http://localhost:3000/api/convert_document/', :document => { :file => params[:document][:file],   :destination_format => params[:document][:destination_format] }
    #RestClient.post 'http://localhost:3000/api/convert_document/', :document => {  :destination_format => params[:document][:destination_format] }
     if params[:document][:upload_method] == 'URL'
       @file_name =  File.basename(URI.parse(params[:document][:url]).path)
       File.open(@file_name, 'wb') do |fo|
          fo.write(open(params[:document][:url]).read)
       end
       @file_content = File.open("./" + @file_name)
       @f_size = @file_content.size if @file_content      
    else 
      @file_name = params[:document][:file].original_filename
      @file_content = params[:document][:file] 
      @f_size = @file_content.size if @file_content
    end

    puts "!"*50
    @current_user = User.find_by_nick('userexample1')    
    
    #Previous checks to prevent null values 
    #if params[:document][:file]
    #  file_name = params[:document][:file].original_filename
    #  file_content = params[:document][:file] 
    #  f_size = file_content.size if file_content
    #end    
    has_extension = File.extname(@file_name).split('.')[1] if @file_name
    ext = has_extension.upcase if has_extension        
    origin_format = Format.find_by_name(ext) if ext
  
    destiny_format_name = params[:document][:destination_format]    
    destiny_format = Format.find_by_name(destiny_format_name) if destiny_format_name # != nil
      
    valid_parameters = true
    @doc_error = nil
    
    puts "/"*50
    puts @file_name
    puts @file_content
    puts @f_size
    puts origin_format
    puts destiny_format
    puts @current_user
    #puts (@f_size <= @current_user.max_document_size) && ((@current_user.used_storage + @f_size) <= @current_user.total_storage_assigned))
    
    
    
    
   
    

    if (file_name && file_content && f_size && origin_format && destiny_format && @current_user && @current_user.max_document.size && 
       (f_size <= @current_user.max_document_size) && ((@current_user.used_storage + f_size) <= @current_user.total_storage_assigned))
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
      if (@current_user.max_document_size)
         @doc_error = '{"status":"max_document_size is nil"}'       
      elsif (f_size <= @current_user.max_document_size)
         @doc_error = '{"status":"max_document_size"}'#"max_document_size"
      elsif (@current_user && ((@current_user.used_storage + f_size) <= @current_user.total_storage_assigned))
         @doc_error = '{"status":"total_storage_assigned"}'#"total_storage_assigned"
      else
          @doc_error = '{"status":"unprocessable_entity"}'#"unprocessable_entity"
      end
      
      valid_parameters = false
    end  
    require 'json'
    respond_to do |f|
      if valid_parameters && @document.save && @document.converted_document.save
        puts "Document created"
        #f.html {redirect_to '/user/dashboard'}
        f.json { render json: @document, status: :created }
      else     
        puts "Error in the validation of the document's parameters"
        #f.html {redirect_to '/user/dashboard'}
        f.json { render json: @doc_error, status: :created }#:unprocessable_entity }
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
