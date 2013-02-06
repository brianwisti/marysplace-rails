require 'test_helper'

class CheckinsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  setup do
    @checkin = checkins(:one)
    UserSession.create users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checkins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checkin" do
    assert_difference('Checkin.count') do
      post :create, checkin: { client_id: @checkin.client.id, user_id: @checkin.user.id, checkin_at: @checkin.checkin_at, notes: @checkin.notes }
    end

    assert_redirected_to new_checkin_path
  end

  test "should show checkin" do
    get :show, id: @checkin
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @checkin
    assert_response :success
  end

  test "should update checkin" do
    put :update, id: @checkin, checkin: { checkin_at: @checkin.checkin_at, notes: @checkin.notes }
    assert_redirected_to checkin_path(assigns(:checkin))
  end

  test "should destroy checkin" do
    assert_difference('Checkin.count', -1) do
      delete :destroy, id: @checkin
    end

    assert_redirected_to checkins_path
  end
end
