require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  fixtures :users

  def setup
  	@user = users(:users0)
  	sign_in @user
  end

  test "should get dashboard" do
    get :dashboard
    assert_response :redirect
    assert_redirected_to admin_users_path
  end

end
