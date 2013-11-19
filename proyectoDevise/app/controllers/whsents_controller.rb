class WhsentsController < ApplicationController
  # GET /whsents
  # GET /whsents.json
  before_filter :find_user
  
  def find_user
    if cookies[:nickname]!= ''
      @user = User.find_by_nick(cookies[:nickname])
    else
      redirect_to '/', notice: 'You must login to get access'
    end  
  end
  
  
  def index
    @webhoook = @user.webhoooks.find(params[:webhoook_id])
    @whsents = @webhoook.whsents

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @whsents }
    end
  end

  # GET /whsents/1
  # GET /whsents/1.json
  def show
    @webhoook = @user.webhoooks.find(params[:webhoook_id])
    @whsents = @webhoook.whsents.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @webhoook }
    end
  end

  # GET /whsents/new
  # GET /whsents/new.json
  def new
    @whsent = Whsents.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @whsent }
    end
  end

  # GET /whsents/1/edit
  def edit
    @webhoook = @user.webhoooks.find(params[:webhoook_id])
    @whsent = @webhoook.whsents.find(params[:id])
  end

  # POST /whsents
  # POST /whsents.json
  def create
    @webhoook = @user.webhoooks.find(params[:webhoook_id])
    @whsent = @webhoook.whsents.build(params[:whsent])
    
    respond_to do |format|
      if @whsent.save
        format.html { redirect_to @whsent, notice: 'whsent was successfully created.' }
        format.json { render json: @whsent, status: :created, location: @whsent }
      else
        format.html { render action: "new" }
        format.json { render json: @whsent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /whsents/1
  # PUT /whsents/1.json
  def update
    @webhoook = @user.webhoooks.find(params[:webhoook_id])
    @whsent = @webhoook.whsents.find(params[:id])

    respond_to do |format|
      if @whsent.update_attributes(params[:whsent])
        format.html { redirect_to @whsent, notice: 'whsent was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @whsent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /whsents/1
  # DELETE /whsents/1.json
  def destroy
    @webhoook = @user.webhoooks.find(params[:webhoook_id])
    @whsent = @webhoook.whsents.find(params[:id])
    @whsent.destroy

    respond_to do |format|
      format.html { redirect_to whsents_url }
      format.json { head :no_content }
    end
  end
  
end
