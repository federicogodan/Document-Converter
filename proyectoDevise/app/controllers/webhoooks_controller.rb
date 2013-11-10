class WebhoooksController < ApplicationController
  # GET /webhoooks
  # GET /webhoooks.json
  before_filter :find_user
  
  def find_user
    @user = User.find_by_nick(cookies[:nickname])
  end
  
  
  def index
    @webhoooks = @user.webhoooks

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @webhoooks }
    end
  end

  # GET /webhoooks/1
  # GET /webhoooks/1.json
  def show
    @webhoook = @user.webhoooks.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @webhoook }
    end
  end

  # GET /webhoooks/new
  # GET /webhoooks/new.json
  def new
    @webhoook = Webhoook.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @webhoook }
    end
  end

  # GET /webhoooks/1/edit
  def edit
    @webhoook = @user.webhoooks.find(params[:id])
  end

  # POST /webhoooks
  # POST /webhoooks.json
  def create
    #@webhoook = webhoook.new(params[:webhoook])
    @webhoook = @user.webhoooks.build(params[:webhoook])
    
    respond_to do |format|
      if @webhoook.save
        format.html { redirect_to @webhoook, notice: 'webhook was successfully created.' }
        format.json { render json: @webhoook, status: :created, location: @webhoook }
      else
        format.html { render action: "new" }
        format.json { render json: @webhoook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /webhoooks/1
  # PUT /webhoooks/1.json
  def update
    @webhoook = @user.webhoooks.find(params[:id])

    respond_to do |format|
      if @webhoook.update_attributes(params[:webhoook])
        format.html { redirect_to @webhoook, notice: 'webhook was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @webhoook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webhoooks/1
  # DELETE /webhoooks/1.json
  def destroy
    @webhoook = @user.webhoooks.find(params[:id])
    @webhoook.destroy

    respond_to do |format|
      format.html { redirect_to webhoooks_url }
      format.json { head :no_content }
    end
  end
end
