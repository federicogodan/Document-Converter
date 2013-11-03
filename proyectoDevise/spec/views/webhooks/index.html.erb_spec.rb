require 'spec_helper'

describe "webhooks/index" do
  before(:each) do
    assign(:webhooks, [
      stub_model(Webhook,
        :url => "Url",
        :deleted => false,
        :user_id => 1
      ),
      stub_model(Webhook,
        :url => "Url",
        :deleted => false,
        :user_id => 1
      )
    ])
  end

  it "renders a list of webhooks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
