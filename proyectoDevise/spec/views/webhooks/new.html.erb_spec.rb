require 'spec_helper'

describe "webhooks/new" do
  before(:each) do
    assign(:webhook, stub_model(Webhook,
      :url => "MyString",
      :deleted => false,
      :user_id => 1
    ).as_new_record)
  end

  it "renders new webhook form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", webhooks_path, "post" do
      assert_select "input#webhook_url[name=?]", "webhook[url]"
      assert_select "input#webhook_deleted[name=?]", "webhook[deleted]"
      assert_select "input#webhook_user_id[name=?]", "webhook[user_id]"
    end
  end
end
