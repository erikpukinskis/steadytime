require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_redirected_to "/auth/sign_in"
  end
end
