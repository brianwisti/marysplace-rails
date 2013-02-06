require 'test_helper'

class PointsEntryTypesControllerTest < ActionController::TestCase
  setup :activate_authlogic

  setup do
    UserSession.create users(:admin)
    @points_entry_type = points_entry_types(:dishes)
    @new_points_entry_type = {
      name: "Make calls",
      default_points: 5
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:points_entry_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create points_entry_type" do
    assert_difference('PointsEntryType.count') do
      post :create, points_entry_type: @new_points_entry_type
    end

    assert_redirected_to points_entry_type_path(assigns(:points_entry_type))
  end

  test "should show points_entry_type" do
    get :show, id: @points_entry_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @points_entry_type
    assert_response :success
  end

  test "should update points_entry_type" do
    put :update, id: @points_entry_type, points_entry_type: { default_points: @points_entry_type.default_points, description: @points_entry_type.description, name: @points_entry_type.name }
    assert_redirected_to points_entry_type_path(assigns(:points_entry_type))
  end

  test "should destroy points_entry_type" do
    assert_difference('PointsEntryType.count', -1) do
      delete :destroy, id: @points_entry_type
    end

    assert_redirected_to points_entry_types_path
  end
end
