require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

end
