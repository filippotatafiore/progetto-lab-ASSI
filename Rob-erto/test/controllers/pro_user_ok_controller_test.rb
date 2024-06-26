require "test_helper"

class ProUserOkControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pro_user_ok_index_url
    assert_response :success
  end
end
