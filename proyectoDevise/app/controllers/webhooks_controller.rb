class WebhooksController < ApplicationController
  # GET /webhooks
  # GET /webhooks.json
  def index
    @webhooks = Webhook.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @webhooks }
    end
  end

  # GET /webhooks/1
  # GET /webhooks/1.json
  def show
    @webhook = Webhook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @webhook }
    end
  end

  # GET /webhooks/new
  # GET /webhooks/new.json
  def new
    @webhook = Webhook.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @webhook }
    end
  end

  # GET /webhooks/1/edit
  def edit
    @webhook = Webhook.find(params[:id])
  end

  # POST /webhooks
  # POST /webhooks.json
  def create
    @webhook = Webhook.new(params[:webhook])

    respond_to do |format|
      if @webhook.save
        format.html { redirect_to @webhook, notice: 'Webhook was successfully created.' }
        format.json { render json: @webhook, status: :created, location: @webhook }
      else
        format.html { render action: "new" }
        format.json { render json: @webhook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /webhooks/1
  # PUT /webhooks/1.json
  def update
    @webhook = Webhook.find(params[:id])

    respond_to do |format|
      if @webhook.update_attributes(params[:webhook])
        format.html { redirect_to @webhook, notice: 'Webhook was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @webhook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webhooks/1
  # DELETE /webhooks/1.json
  def destroy
    @webhook = Webhook.find(params[:id])
    @webhook.destroy

    respond_to do |format|
      format.html { redirect_to webhooks_url }
      format.json { head :no_content }
    end
  end
end

