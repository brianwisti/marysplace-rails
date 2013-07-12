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
        assert_select 'li', 6
      end
    end
  end

  test "Front Desk navbar" do
    UserSession.create users(:front_desk)
    get :index
    assert_response :success
    assert_select 'a[href=/users]', false
    assert_select 'a[href=/clients]', "Clients"
    assert_select 'a[href=/points_entries]', false
    assert_select 'a[href=/checkins]', "Checkins"
    assert_select 'a[href=/points_entry_types]', false
    assert_select 'a[href=/client_flags]', false
    assert_select 'a.checkin-count', '0'
  end

  test "Staff navbar" do
    UserSession.create users(:staff)
    get :index

    assert_select 'div.flags', 1
    assert_select 'a[href=/users]', "Users"
    assert_select 'a[href=/clients]', "Clients"
    assert_select 'a[href=/points_entries]', "Points Log"
    assert_select 'a[href=/checkins]', "Checkins"
    assert_select 'a[href=/points_entry_types]', "Points Entry Types"
    assert_select 'a[href=/client_flags]', "Client Flags"
  end

  test "Missing email notification" do
    UserSession.create users(:new_hire)
    get :index
    assert_select 'div.alert', 1
  end
end
