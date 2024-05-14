require "test_helper"

class HelpControllerTest < ActionDispatch::IntegrationTest
  test "should get help" do
    get help_help_url
    assert_response :success
  end
end
