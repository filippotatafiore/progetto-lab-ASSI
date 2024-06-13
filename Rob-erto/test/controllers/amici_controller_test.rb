require "test_helper"

class AmiciControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get amici_index_url
    assert_response :success
  end
end
