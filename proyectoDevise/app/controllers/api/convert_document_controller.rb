class Api::ConvertDocumentController < ApplicationController#ApiController
  
  def create
    
    @current_user = User.first
    puts params.to_json
    
    #Previous checks to prevent null values 
    if params[:file]
      file_name = params[:file].original_filename
      file_content = params[:file] 
      f_size = file_content.size if file_content
    end    
    destiny_format_name = params[:destination_format]    
    destiny_format = Format.find_by_name(destiny_format_name) if destiny_format_name # != ''
    has_extension = File.extname(file_name).split('.')[1] if file_name
    ext = has_extension.upcase if has_extension   

    valid_parameters = true
    
    if (file_name && file_content && f_size && destiny_format && @current_user && ext)
      #Creating association between the user and the document uploaded. Also creating the converted document's object
  
      document = Document.new(name:file_name,expired:false,size:f_size)
      document.file = params[:file]  
      puts document
      
      origin_format = Format.find_by_name(destiny_format_name) if destiny_format_name
  
      document.format = origin_format
      document.user = @current_user
      document.converted_document = ConvertedDocument.new
      document.converted_document.set_to_converting
      document.converted_document.format = destiny_format
    else
      valid_parameters = false
    end  

    respond_to do |f|
      if valid_parameters && document.save && document.converted_document.save
        puts "Document created"
        f.json { render json: document, status: :created }
      else
        puts "Error in the validation of the document's parameters"
        f.json { render json: document.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    ext = params[:id]
    reg_filename = Format.find_by_name(ext)
    formats = []
    reg_filename.destinies.each do |f|
      formats.push(f.name)
    end
    render :json => formats
  end
end
