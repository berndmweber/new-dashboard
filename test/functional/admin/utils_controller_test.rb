require 'test_helper'

class Admin::UtilsControllerTest < ActionController::TestCase
  test "should get generate_cert" do
    get :generate_cert
    assert_response :success
  end

end
