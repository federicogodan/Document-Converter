require 'spec_helper'

describe "Whsents" do
  describe "GET /whsents" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get whsents_path
      response.status.should be(200)
    end
  end
end
