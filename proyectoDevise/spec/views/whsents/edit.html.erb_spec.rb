require 'spec_helper'

describe "whsents/edit" do
  before(:each) do
    @whsent = assign(:whsent, stub_model(Whsent,
      :url => "MyString",
      :state => 1,
      :attempts => 1,
      :webhoook_id => 1
    ))
  end

  it "renders the edit whsent form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", whsent_path(@whsent), "post" do
      assert_select "input#whsent_url[name=?]", "whsent[url]"
      assert_select "input#whsent_state[name=?]", "whsent[state]"
      assert_select "input#whsent_attempts[name=?]", "whsent[attempts]"
      assert_select "input#whsent_webhoook_id[name=?]", "whsent[webhoook_id]"
    end
  end
end
