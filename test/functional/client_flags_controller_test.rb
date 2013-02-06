require 'test_helper'
require 'pp'

class ClientFlagsControllerTest < ActionController::TestCase
  fixtures :client_flags, :users, :clients
  setup :activate_authlogic

  setup do
    @client_flag = client_flags(:one)

    @attributes = {
      client_id:       @client_flag.client_id,
      action_required: @client_flag.action_required, 
      consequence:     @client_flag.consequence, 
      description:     @client_flag.description, 
      expires_on:      @client_flag.expires_on, 
      is_blocking:     @client_flag.is_blocking
    }
    UserSession.create users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:client_flags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client_flag" do
    assert_difference('ClientFlag.count') do
      post :create, client_flag: @attributes
    end

    assert_redirected_to client_flag_path(assigns(:client_flag))
  end

  test "should show client_flag" do
    get :show, id: @client_flag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client_flag
    assert_response :success
  end

  test "should update client_flag" do
    put :update, id: @client_flag, client_flag: @attributes
    assert_redirected_to client_flag_path(assigns(:client_flag))
  end

  test "should destroy client_flag" do
    assert_difference('ClientFlag.count', -1) do
      delete :destroy, id: @client_flag
    end

    assert_redirected_to client_flags_path
  end
end
