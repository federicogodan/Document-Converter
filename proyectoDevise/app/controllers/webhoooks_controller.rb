class WebhoooksController < ApplicationController
  # GET /webhoooks
  # GET /webhoooks.json
  before_filter :find_user
  
  def find_user
    if cookies[:nickname]!= ''
      @user = User.find_by_nick(cookies[:nickname])
    else
      redirect_to '/', notice: 'You must login to get access'
    end  
  end
  
  
  def index
    @webhoooks = @user.webhoooks

    respond_to do |format|
      format.html { render :layout => false  } 
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
        #format.html { redirect_to @webhoook, notice: 'webhook was successfully created.' }
        format.json { render json: @webhoook, status: :created, location: @webhoook }
      else
        #format.html { render action: "new" }
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
  
  def self.resend_notifications
    max_attempts = 3
    @whsents = Whsent.where(state:1)
    @whsents.each do |s|
      code, message, body = Webhook.post(s.url, :notification => s.notification.to_s, :data => s.urldoc)
      
      s.attempts = s.attempts + 1
      
      if code == '200'
        s.state = 0
      else
        if s.attempts == max_attempts
          s.state = 2 
        end
      end
      s.save
    end
  end
  
end
