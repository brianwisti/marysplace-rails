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
    UserSession.create users(:front_desk)

    get :edit, id: users(:admin)
    assert_redirected_to root_url
  end

  test "should get new" do
    UserSession.create users(:admin)
    get :new
    assert_response :success
  end

  test "should not allow anonymous creation of new users" do
    attributes = {
      login:                 'newuser',
      password:              'password',
      password_confirmation: 'password'
    }

    assert_difference('User.count', 0) do
      post :create, user: attributes
    end
  end

  test "should create a new user" do
    UserSession.create users(:admin)

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

  test "users can update themselves" do
    UserSession.create users(:staff)
    put :update, id: users(:staff), user: { login: 'newlogin' }
    assert_equal "newlogin", assigns(:user).login
  end

  test "admin can update anyone" do
    UserSession.create users(:admin)
    put :update, id: users(:staff), user: { login: 'newlogin' }
    assert_equal "newlogin", assigns(:user).login
  end

  test "user cannot update just any user" do
    UserSession.create users(:staff)
    old_login = users(:admin).login
    put :update, id: users(:admin), user: { login: 'newlogin' }
    assert_equal old_login, users(:admin).login
  end

  test "a bad update sends user back to the profile" do
    UserSession.create users(:staff)
    put :update, id: users(:staff), user: { 
      password:              'wook',
      password_confirmation: 'wick'
    }
    assert_template :edit
  end

end
