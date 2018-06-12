require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  include Authlogic::TestCase
  setup :activate_authlogic

  def setup
    @message = messages :site_update
    @staff_user = users :staff
    @attributes = {
      title: "New Title",
      content: "New Content",
      author_id: users(:admin),
    }
  end

  test "anonymous user cannot access index" do
    get :index

    assert_redirected_to new_user_session_url
  end

  test "anonymous user cannot show a message" do
    get :show, id: message

    assert_redirected_to new_user_session_url
  end

  test "anonymous user cannot access new" do
    get :new

    assert_redirected_to new_user_session_url
  end

  test "anonymous user cannot create a message" do
    post :create, message: @attributes
    
    assert_redirected_to new_user_session_url
  end

  test "anonymous user cannot access edit" do
    get :edit, id: message

    assert_redirected_to new_user_session_url
  end

  test "Staff user can access messages index" do
    UserSession.create @staff_user
    get :index

    assert_response :success
    assert_template :index
  end

  test "Staff user can view a message" do
    UserSession.create @staff_user
    get :show, id: @message

    assert_response :success
    assert_equal @message, assigns(:message)
  end

  test "Staff user cannot edit a message" do
    UserSession.create @staff_user
    get :edit, id: @message

    assert_response :redirect
  end

end
