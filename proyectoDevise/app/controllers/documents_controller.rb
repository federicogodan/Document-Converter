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
    puts params[:document][:file].original_filename
    puts '#'*50
      #{}"document"=>{"document_number"=>"12", , "name"=>"fsdfs", "file"=>#<ActionDispatch::Http::UploadedFile:0x000000056b46a8 @original_filename="modules.order", @content_type="application/octet-stream", @headers="Content-Disposition: form-data; name=\"document[file]\"; filename=\"modules.order\"\r\nContent-Type: application/octet-stream\r\n", @tempfile=#<Tempfile:/tmp/RackMultipart20131024-13630-n9vm71>>}, "commit"=>"Sign up"}
   
    @document = Document.new
    @document.user_id = User.find_by_nick(cookies[:nickname]).id
    @document.format_id = params[:document][:format_id]
    @document.file = params[:document][:file]
    @document.name = params[:document][:file].original_filename
    puts params[:document][:file]


    respond_to do |format|

      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
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
