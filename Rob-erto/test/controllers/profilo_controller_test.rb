require "test_helper"

class ProfiloControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get profilo_index_url
    assert_response :success
  end
end
