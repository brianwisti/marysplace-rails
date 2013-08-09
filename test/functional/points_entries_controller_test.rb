require 'test_helper'

class PointsEntriesControllerTest < ActionController::TestCase
  setup :activate_authlogic

  setup do
    UserSession.create users(:admin)
    @points_entry = points_entries(:one)
    @client = clients(:amy_a)
    @attributes = {
      client_id: @points_entry.client.id,
      points_entry_type_id: @points_entry.points_entry_type.id,
      bailed: @points_entry.bailed,
      performed_on: @points_entry.performed_on,
      points: @points_entry.points
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:points_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create points_entry" do
    assert_difference('PointsEntry.count') do
      post :create, points_entry: @attributes
    end

    assert_redirected_to points_entry_path(assigns(:points_entry))
  end

  test "should show points_entry" do
    get :show, id: @points_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @points_entry
    assert_response :success
  end

  test "should update points_entry" do
    put :update, id: @points_entry, points_entry: { bailed: @points_entry.bailed, performed_on: @points_entry.performed_on, points: @points_entry.points }
    assert_redirected_to points_entry_path(assigns(:points_entry))
  end

  test "should destroy points_entry" do
    assert_difference('PointsEntry.count', -1) do
      delete :destroy, id: @points_entry
    end

    assert_redirected_to points_entries_path
  end
end
