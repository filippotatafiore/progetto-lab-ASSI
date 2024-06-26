require "test_helper"

class ProUserFailureControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pro_user_failure_index_url
    assert_response :success
  end
end
