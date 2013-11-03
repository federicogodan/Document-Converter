require "spec_helper"

describe WebhooksController do
  describe "routing" do

    it "routes to #index" do
      get("/webhooks").should route_to("webhooks#index")
    end

    it "routes to #new" do
      get("/webhooks/new").should route_to("webhooks#new")
    end

    it "routes to #show" do
      get("/webhooks/1").should route_to("webhooks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/webhooks/1/edit").should route_to("webhooks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/webhooks").should route_to("webhooks#create")
    end

    it "routes to #update" do
      put("/webhooks/1").should route_to("webhooks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/webhooks/1").should route_to("webhooks#destroy", :id => "1")
    end

  end
end
