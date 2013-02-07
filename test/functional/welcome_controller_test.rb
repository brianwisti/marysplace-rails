require 'test_helper'

require 'pp'

class WelcomeControllerTest < ActionController::TestCase
  fixtures :client_flags, :users, :clients
  setup :activate_authlogic

  test "should get index" do
    get :index
    assert_redirected_to controller: :user_sessions, action: :new
  end

  test "Admin navbar" do
    UserSession.create users(:admin)
    get :index
    assert_response :success

    assert_select 'div.navbar' do
      assert_select 'ul.nav' do
        assert_select 'li', 7
      end
    end
  end

  test "Staff navbar" do
    UserSession.create users(:staff)
    get :index
    assert_response :success

    assert_select 'div.navbar' do
      assert_select 'ul.nav' do
        assert_select 'li', 5
      end
    end
  end

  test "Volunteer navbar" do
    UserSession.create users(:front_desk)
    get :index
    assert_response :success

    assert_select 'div.navbar' do 
      assert_select 'ul.nav' do |element|
        assert_select 'li', 1
      end
    end
  end

  test "Staff welcome" do
    UserSession.create users(:staff)
    get :index

    assert_select 'div.flags', 1
  end
end
