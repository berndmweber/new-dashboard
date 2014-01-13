require 'test_helper'

class Admin::CustomersControllerTest < ActionController::TestCase
  fixtures :users

  setup do
    @customer = customers(:customers0)
    @user = users(:users0)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer" do
    Customer.delete_all
    assert_difference('Customer.count') do
      post :create, customer: { githubrepo_url: @customer.githubrepo_url, name: @customer.name, puppetdb_url: @customer.puppetdb_url, puppetmaster_url: @customer.puppetmaster_url }
    end

    assert_redirected_to admin_customer_path(assigns(:customer))
  end

  test "should show customer" do
    get :show, id: @customer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer
    assert_response :success
  end

  test "should update customer" do
    put :update, id: @customer, customer: { githubrepo_url: @customer.githubrepo_url, name: @customer.name, puppetdb_url: @customer.puppetdb_url, puppetmaster_url: @customer.puppetmaster_url }
    assert_redirected_to admin_customer_path(assigns(:customer))
  end

  test "should destroy customer" do
    assert_difference('Customer.count', -1) do
      delete :destroy, id: @customer
    end

    assert_redirected_to admin_customers_path
  end
end
