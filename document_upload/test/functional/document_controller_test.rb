require 'test_helper'

class DocumentControllerTest < ActionController::TestCase
  test "should get upload_document" do
    get :upload_document
    assert_response :success
  end

end
