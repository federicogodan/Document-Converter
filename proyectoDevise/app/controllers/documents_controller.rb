class DocumentsController < ApplicationController

  #before_filter :authenticate_user!
  
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
    
    #Previous checks to prevent null values 
    if params[:document][:file]
      file_name = params[:document][:file].original_filename
      file_content = params[:document][:file] 
      f_size = file_content.size if file_content
    end    
    id_destiny_format = params[:document]["format_id"]    
    destiny_format = Format.find_by_id(id_destiny_format) if id_destiny_format # != ''
    us = User.find_by_nick(cookies[:nickname])
    has_extension = File.extname(file_name).split('.')[1] if file_name
    ext = has_extension.upcase if has_extension
    #file_path = params[:document][:uploaded_file].path    

    valid_parameters = true
    if (file_name && file_content && f_size && destiny_format && us && ext)
      #Creating association between the user and the document uploaded. Also creating the converted document's object
  
      @document = Document.new(name:file_name,expired:false,size:f_size)
      @document.file = params[:document][:file]  
  
      origin_format = Format.find_by_name(ext) if ext
  
      @document.format = origin_format
      @document.user = us
      @document.converted_document = ConvertedDocument.new
      @document.converted_document.set_to_converting
      @document.converted_document.format = destiny_format
    else
      valid_parameters = false
    end  

    respond_to do |f|
      if valid_parameters && @document.converted_document.save && @document.save && us.save

        f.html { redirect_to @document, notice: 'Document was successfully created.' }
        f.json { render json: @document, status: :created, location: @document }
      else
        puts "Error in the validation of the document's parameters"
        f.html { redirect_to action: "new", notice: 'An error has ocurred, please try to upload again'}
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
