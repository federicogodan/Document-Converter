require 'spec_helper'

describe "webhoooks/edit" do
  before(:each) do
    @webhoook = assign(:webhoook, stub_model(Webhoook,
      :url => "MyString",
      :deleted => false,
      :user_id => 1
    ))
  end

  it "renders the edit webhoook form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", webhoook_path(@webhoook), "post" do
      assert_select "input#webhoook_url[name=?]", "webhoook[url]"
      assert_select "input#webhoook_deleted[name=?]", "webhoook[deleted]"
      assert_select "input#webhoook_user_id[name=?]", "webhoook[user_id]"
    end
  end
end
