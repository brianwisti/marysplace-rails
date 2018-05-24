require 'test_helper'

class ClientFlagsControllerTest < ActionController::TestCase
  include Authlogic::TestCase

  setup :activate_authlogic

  def setup
    @user = users :simple
    @staff = users :staff
  end

  test "index should be unavailable to anonymous users" do
    get :index

    assert_redirected_to new_user_session_url
    assert_nil assigns(:client_flags),
      "Should be redirected before client flags are loaded"
  end

  test "resolved should be unavailable to anonymous users" do
    get :resolved

    assert_redirected_to new_user_session_url
    assert_nil assigns(:client_flags),
      "Should be redirected before client flags are loaded"
  end

  test "index should be available to staff" do
    UserSession.create @staff
    get :index

    assert_template :index
    assert_not_empty assigns(:client_flags),
      "some flags should be visible"
  end

  test "resolved should be available to staff" do
    UserSession.create @staff
    get :resolved

    assert_template :resolved
  end

  test "show should be available to staff" do
    flag = client_flags :amy_c_bail
    UserSession.create @staff
    get :show, id: flag

    assert_template :show
    assert_equal flag, assigns(:client_flag) 
  end
end
