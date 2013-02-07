require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "should get index" do
    UserSession.create users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "anonymous should not see users" do
    get :show, id: users(:admin)
    assert_redirected_to new_user_session_path
  end

  test "anonymous should not edit users" do
    get :edit, id: users(:admin)
    assert_redirected_to new_user_session_path
  end

  test "should show user" do
    UserSession.create users(:admin)
    get :show, id: users(:admin)
    assert_response :success
  end

  test "shows specified user to user" do
    UserSession.create users(:admin)
    get :show, id: users(:staff)
    assert_response :success
  end

  test "users can edit their own profile" do
    UserSession.create users(:admin)
    get :edit, id: users(:admin)
    assert_response :success
  end

  test "normal users cannot edit other profiles" do
    UserSession.create users(:staff)
    assert_raises(CanCan::AccessDenied) {
      get :edit, id: users(:admin)
    }
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create a new user" do
    attributes = {
      login:                 'newuser',
      password:              'password',
      password_confirmation: 'password'
    }

    assert_difference('User.count') do
      post :create, user: attributes
    end
  end

  test "should reload form with errors" do
    attributes = {
      login:                 'newuser',
      password:              'password',
    }

    assert_difference('User.count', 0) do
      post :create, user: attributes
    end
  end

  test "admin can update any user" do
    UserSession.create users(:staff)
    put :update, id: users(:staff), user: { login: 'newlogin' }
    assert_equal "newlogin", assigns(:user).login
  end

end
