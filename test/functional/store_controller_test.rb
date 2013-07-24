require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  setup :activate_authlogic

  setup do
    @user = users(:admin)
    UserSession.create @user
    @client = clients(:amy_a)
    @cart = StoreCart.start(@client, @user)
    @catalog_item = catalog_items(:general)
    @cart_item_attributes = {
      catalog_item_id: @catalog_item,
      cost:            @catalog_item.cost
    }
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get start" do
    assert_difference('StoreCart.count') do
      put :start, { shopper_id: @client }
      assert_response :redirect
    end
  end

  test "should get show" do
    get :show, id: @cart
    assert_response :success
  end

  test "should get finish" do
    put :finish, id: @cart
    assert_response :redirect
  end

  test "should get open" do
    get :open
    assert_response :success
  end

  test "should get add" do
    assert_difference('StoreCartItem.count') do
      put :add, id: @cart, store_cart_item: @cart_item_attributes
      assert_response :redirect
    end
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
