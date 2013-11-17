class DocumentsController < ApplicationController
  
  before_filter :find_user
  
  def find_user
    if cookies[:nickname]!= ''
      @user = User.find_by_nick(cookies[:nickname])
    else
      redirect_to '/', notice: 'You must login to get access'
    end  
  end
  
  
  # GET /documents
  # GET /documents.json
  def index
    @current_user = User.find_by_nick('userexample1')
    @documents = @current_user.documents
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = @user.documents.find(params[:id])

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
      format.html { render :layout => false  } 
      format.json { render json: @document }
    end
  end

  # POST /documents
  # POST /documents.json
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
       #@f_size = @file_content.size if @file_content      
    else 
      @file_name = params[:document][:file].original_filename
      @file_content = params[:document][:file] 
      #@f_size = @file_content.size if @file_content
    end 
    
    request = RestClient::Request.new(
          :method => :post,
          :url => 'http://localhost:3000/api/convert_document/',
          :payload => {
            :multipart => true,
            :document => { :file =>  @file_content,
              :destination_format => params[:document][:destination_format]
              }
          })      
    response = request.execute
    
   
    puts "respond!"
    respond_to do |format|
      format.json { head :no_content }
    end
    
  end

  def update
    @document = @user.documents.find(params[:id])

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
    @document = @user.documents.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
end
