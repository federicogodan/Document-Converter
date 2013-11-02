class DocumentsController < ApplicationController
  # GET /documents
  # GET /documents.json
  def index 
    @documents = User.find_by_nick(cookies[:nickname]).documents

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end


  # POST /documents
  # POST /documents.json
  def create
    #Create document from upload
        
    #us = User.find_by_nick(cookies[:nickname])
    #puts "document-new"
    #@document = Document.new(params[:document][:file])
    #@document.user = us
    #TODO Obtener format original sacando del name, sacar del nombre extension
    #f = Format.find(params[:document][:format_id])
    #@document.format = f    
    #converted document initialization
    #@document.converted_document = ConvertedDocument.new
    #@document.converted_document.format_id = 2
    #@document.converted_document.set_to_converting
      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@"
      puts "Los parametros son: " 
      puts params.to_json
      #puts params[:document][:uploaded_file].original_filename
      puts "222222222222222222222222222"      
      file_name = params[:document][:file].original_filename  if params[:document][:file]
      puts "File name es: "
      puts file_name
      
      id_destiny_format = params[:document]["format_id"]
      destiny_format = Format.find(id_destiny_format)
      puts "El formato destino es: "
      puts destiny_format
            
      #file_path = params[:document][:uploaded_file].path
      file_content = params[:document][:file] if params[:document][:file]
      puts "File content es: "
      puts file_content
                  
      f_size = file_content.size if file_content
      puts "El f_size es:"
      puts f_size      
      
      
    #Association between user and document
      us = User.find_by_nick(cookies[:nickname])                
      puts "El nick del usuario es:"
      puts us.nick
                  
      @document = Document.new(name:file_name,expired:false,size:f_size)
      @document.file = params[:document][:file]      
    
      ext = File.extname(file_name).split('.')[1].upcase if file_name       
      puts "El nombre de la extension es:"
      puts ext
      
      origin_format = Format.find_by_name(ext) if ext
      puts "El formato origen es: "
      puts origin_format.id
      
      @document.format = origin_format            
      @document.user = us 
      @document.converted_document = ConvertedDocument.new 
      @document.converted_document.set_to_converting
      @document.converted_document.format = destiny_format
      could_save_convdoc = @document.converted_document.save
      
      puts "estoy apuntooo de salvarrrrr @documentttttt ACA"
      could_save_doc =@document.save     
      
      puts "supuestamente ya salveeee y el valor eraaa: "
      puts could_save_doc
      
      #conv_doc = 
      #conv_doc.set_to_converting    
      #conv_doc.format = destiny_format
      
      #if could_save_doc               
      #   puts "holaaaaa pude guardar doc!!!!!!!!!!!!"
      #   conv_doc.document = @document
      #   could_save_convdoc= conv_doc.save 
      #   @document.converted_document = conv_doc
      #end
         
    respond_to do |f|
      if could_save_doc && could_save_convdoc && us.documents.push(@document) && us.save                                   
                  
        f.html { redirect_to @document, notice: 'Document was successfully created.' }
        f.json { render json: @document, status: :created, location: @document }
      else
        f.html { render action: "new" }
        f.json { render json: @document.errors, status: :unprocessable_entity }
      end             
    end  
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
end
