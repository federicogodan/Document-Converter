require "spec_helper"

describe WebhoooksController do
  describe "routing" do

    it "routes to #index" do
      get("/webhoooks").should route_to("webhoooks#index")
    end

    it "routes to #new" do
      get("/webhoooks/new").should route_to("webhoooks#new")
    end

    it "routes to #show" do
      get("/webhoooks/1").should route_to("webhoooks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/webhoooks/1/edit").should route_to("webhoooks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/webhoooks").should route_to("webhoooks#create")
    end

    it "routes to #update" do
      put("/webhoooks/1").should route_to("webhoooks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/webhoooks/1").should route_to("webhoooks#destroy", :id => "1")
    end

  end
end
