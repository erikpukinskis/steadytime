require "test_helper"

class NowControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get now_index_url
    assert_response :success
  end
end
