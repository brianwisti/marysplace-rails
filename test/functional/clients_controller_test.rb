require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  setup do
    UserSession.create users(:admin)
    @client = clients(:amy_a)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post :create, client: { added_by_id: @client.added_by_id, birthday: @client.birthday, current_alias: "Amy A. 1", full_name: @client.full_name, last_edited_by_id: @client.last_edited_by_id, notes: @client.notes, oriented_on: @client.oriented_on, other_aliases: @client.other_aliases, phone_number: @client.phone_number, point_balance: @client.point_balance }
    end

    assert_redirected_to client_path(assigns(:client))
  end

  test "should show client" do
    get :show, id: @client
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client
    assert_response :success
  end

  test "should update client" do
    put :update, id: @client, client: { added_by_id: @client.added_by_id, birthday: @client.birthday, current_alias: @client.current_alias, full_name: @client.full_name, last_edited_by_id: @client.last_edited_by_id, notes: @client.notes, oriented_on: @client.oriented_on, other_aliases: @client.other_aliases, phone_number: @client.phone_number, point_balance: @client.point_balance }
    assert_redirected_to client_path(assigns(:client))
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete :destroy, id: @client
    end

    assert_redirected_to clients_path
  end
end
