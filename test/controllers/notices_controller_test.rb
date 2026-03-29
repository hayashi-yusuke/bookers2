require "test_helper"

class NoticesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get notices_new_url
    assert_response :success
  end

  test "should get create" do
    get notices_create_url
    assert_response :success
  end
end
