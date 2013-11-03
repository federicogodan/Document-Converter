require 'spec_helper'

describe "webhoooks/new" do
  before(:each) do
    assign(:webhoook, stub_model(Webhoook,
      :url => "MyString",
      :deleted => false,
      :user_id => 1
    ).as_new_record)
  end

  it "renders new webhoook form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", webhoooks_path, "post" do
      assert_select "input#webhoook_url[name=?]", "webhoook[url]"
      assert_select "input#webhoook_deleted[name=?]", "webhoook[deleted]"
      assert_select "input#webhoook_user_id[name=?]", "webhoook[user_id]"
    end
  end
end
