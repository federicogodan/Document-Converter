require "spec_helper"

describe WhsentsController do
  describe "routing" do

    it "routes to #index" do
      get("/whsents").should route_to("whsents#index")
    end

    it "routes to #new" do
      get("/whsents/new").should route_to("whsents#new")
    end

    it "routes to #show" do
      get("/whsents/1").should route_to("whsents#show", :id => "1")
    end

    it "routes to #edit" do
      get("/whsents/1/edit").should route_to("whsents#edit", :id => "1")
    end

    it "routes to #create" do
      post("/whsents").should route_to("whsents#create")
    end

    it "routes to #update" do
      put("/whsents/1").should route_to("whsents#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/whsents/1").should route_to("whsents#destroy", :id => "1")
    end

  end
end
