require 'spec_helper'

describe "webhoooks/show" do
  before(:each) do
    @webhoook = assign(:webhoook, stub_model(Webhoook,
      :url => "Url",
      :deleted => false,
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url/)
    rendered.should match(/false/)
    rendered.should match(/1/)
  end
end
