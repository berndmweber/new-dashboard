require 'test_helper'

class Admin::UtilsControllerTest < ActionController::TestCase
  fixtures :users

  def setup
  	@user = users(:users0)
  	sign_in @user
  end

  test "should get generate_cert" do
  	get :generate_cert
    assert_response :success
  end

end
