require 'test_helper'

class Admin::PuppetmastersControllerTest < ActionController::TestCase
  fixtures :users

  setup do
    @puppetmaster = puppetmasters(:puppetmasters0)
    @user = users(:users0)
     sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:puppetmasters)
  end

  test "should get new" do
    get :new, :customer => '2'
    assert_response :success
  end

  test "should create puppetmaster" do
    assert_difference('Puppetmaster.count') do
      post :create, puppetmaster: { port: @puppetmaster.port, sslCert: @puppetmaster.sslCert, sslKey: @puppetmaster.sslKey, url: @puppetmaster.url, customer_id: '2' }
    end

    # assert_redirected_to admin_customer_path()
  end

  test "should show puppetmaster" do
    get :show, id: @puppetmaster
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @puppetmaster
    assert_response :success
  end

  test "should update puppetmaster" do
    put :update, id: @puppetmaster, puppetmaster: { port: @puppetmaster.port, sslCert: @puppetmaster.sslCert, sslKey: @puppetmaster.sslKey, url: @puppetmaster.url, customer_id: '2' }
    assert_redirected_to admin_puppetmaster_path(assigns(:puppetmaster))
  end

  test "should destroy puppetmaster" do
    assert_difference('Puppetmaster.count', -1) do
      delete :destroy, id: @puppetmaster
    end

    # assert_redirected_to admin_customer_path()
  end
end
