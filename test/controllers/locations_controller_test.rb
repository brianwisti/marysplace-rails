require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  include Authlogic::TestCase

  setup :activate_authlogic

  def setup
    @staff = users :staff
    @location = locations :day_shelter
    @attributes = {
      name: "New Location"
    }
  end

  test "anonymous user cannot access index" do
    get :index

    assert_redirected_to new_user_session_url
  end

  test "anonymous user cannot access show" do
    get :show, id: @location

    assert_redirected_to new_user_session_url
  end

  test "anonymous user cannot access new" do
    get :new

    assert_redirected_to new_user_session_url
  end

  test "anonymous user cannot access edit" do
    get :edit, id: @location

    assert_redirected_to new_user_session_url
  end

  test "anonymous user cannot access create" do
    initial_location_count = Location.count
    post :create, location: @attributes

    assert_redirected_to new_user_session_url
    assert_equal initial_location_count, Location.count
  end

  test "anonymous user cannot access update" do
    put :update, id: @location, location: @attributes

    assert_redirected_to new_user_session_url
  end

  test "anonymous user cannot access destroy" do
    initial_location_count = Location.count
    delete :destroy, id: @location

    assert_redirected_to new_user_session_url
    assert_equal initial_location_count, Location.count
  end
end
