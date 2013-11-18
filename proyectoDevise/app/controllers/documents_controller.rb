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
    @current_user = User.find_by_nick('userexample0')
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
    
  #   if params[:document][:upload_method] == 'URL'
  #     @file_name =  File.basename(URI.parse(params[:document][:url]).path)
  #     File.open(@file_name, 'wb') do |fo|
  #        fo.write(open(params[:document][:url]).read)
  #     end
  #     @file_content = File.open("./" + @file_name)
  #     #@f_size = @file_content.size if @file_content      
   # else 
     # @file_name = params[:document][:file].original_filename
     # @file_content = params[:document][:file] 
      # @f_size = @file_content.size if @file_content
   # end
     
    api_key = @user.api_key
    secret_key = @user.secret_key
    url = 'http://localhost:3000/api/convert_document/'
    hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_key, url)).strip    
        
    if params[:document][:upload_method] == 'URL'
       @content = params[:document][:file].original_filename
    else  
       @content = @file_content
    end    
        
        
    
    request = RestClient::Request.new(
          :method => :post,
          :url => url,
          :payload => {
            :multipart => true,
            :api_key => api_key,
            :hash => hash,
            :document => { :file =>  @content,
              :destination_format => params[:document][:destination_format],
              :upload_method => params[:document][:upload_method]
              }
          })      

    response = request.execute    
    
     puts "******************************************************************************************"
    puts "******************************************************************************************"  
    puts "******************************************************************************************"
    puts "******************************************************************************************"  
    puts "******************************************************************************************"
    puts "******************************************************************************************"  
    puts "******************************************************************************************"
    puts "******************************************************************************************"  
    puts "******************************************************************************************"
    puts "******************************************************************************************"    
    puts response.to_s
    puts "******************************************************************************************"
    puts "******************************************************************************************"
    puts "******************************************************************************************"
    puts "******************************************************************************************"  
    puts "******************************************************************************************"
    puts "******************************************************************************************"  
    puts "******************************************************************************************"
    puts "******************************************************************************************"  
    puts "******************************************************************************************"
    puts "******************************************************************************************"  
    puts "******************************************************************************************"
    puts "******************************************************************************************"  
    puts "******************************************************************************************"
    puts "******************************************************************************************"  
    puts "******************************************************************************************"
    puts "******************************************************************************************"  
           
    respond_to do |format|
      format.html { redirect_to '/user/dashboard'}
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

  def get_formats
    api_key = @user.api_key
    secret_key = @user.secret_key
    url = 'http://localhost:3000/api/convert_document/'
    hash = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_key, url)).strip
    ext = params[:extension]
    request = RestClient::Request.new(
          :method => :get,
          :url => url,
          :payload => {
            :multipart => true,
            :api_key => api_key,
            :hash => hash,
            :extension => ext
          })      
    response = request.execute
    render :json => response    
  end

  def show_api_keys
  end

  def regenerate_keys    
    #creates the public key
    begin
      token = SecureRandom.urlsafe_base64(nil, false)
    end until !User.exists?(api_key: token)
    api_key = token

    #creates the secret key
    begin
      token = SecureRandom.urlsafe_base64(nil, false)
    end until !User.exists?(api_key: token)
    secret_key = token

    @user.api_key = api_key
    @user.secret_key = secret_key

    @user.save
  end

end
