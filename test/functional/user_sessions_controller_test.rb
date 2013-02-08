require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create new session" do
    u = User.create!(login: 'user', 
                     password: 'password', 
                     password_confirmation: 'password')
    put :create, user_session: { login: 'user', password: 'password' }
    assert_redirected_to root_path
  end
end
