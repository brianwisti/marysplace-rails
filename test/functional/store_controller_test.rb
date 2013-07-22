require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  setup :activate_authlogic

  setup do
    @user = users(:admin)
    @client = clients(:amy_a)
    UserSession.create @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get start" do
    assert_difference('StoreCart.count') do
      put :start, { shopper_id: @client }
      assert_response :success
    end
  end

  test "should get finish" do
    get :finish
    assert_response :success
  end

  test "should get open" do
    get :open
    assert_response :success
  end

  test "should get add" do
    get :add
    assert_response :success
  end

  test "should get remove" do
    get :remove
    assert_response :success
  end

  test "should get change" do
    get :change
    assert_response :success
  end

end
