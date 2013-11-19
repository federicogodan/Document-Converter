require 'spec_helper'

describe "whsents/index" do
  before(:each) do
    assign(:whsents, [
      stub_model(Whsent,
        :url => "Url",
        :state => 1,
        :attempts => 2,
        :webhoook_id => 3
      ),
      stub_model(Whsent,
        :url => "Url",
        :state => 1,
        :attempts => 2,
        :webhoook_id => 3
      )
    ])
  end

  it "renders a list of whsents" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
