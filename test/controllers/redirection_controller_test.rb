require 'test_helper'

class RedirectionControllerTest < ActionController::TestCase
  test "should get login_user_type" do
    get :login_user_type
    assert_response :success
  end

end
