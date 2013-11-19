require 'spec_helper'

describe "whsents/show" do
  before(:each) do
    @whsent = assign(:whsent, stub_model(Whsent,
      :url => "Url",
      :state => 1,
      :attempts => 2,
      :webhoook_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Url/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
