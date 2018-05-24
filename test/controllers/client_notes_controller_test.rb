require 'test_helper'

class ClientNotesControllerTest < ActionController::TestCase
  include Authlogic::TestCase

  setup :activate_authlogic

  def setup
    @client = clients :amy_a
    @client_note = client_notes :amy_a_bonus
    @admin = users :admin
    @attributes = {
      title:     "Note Title",
      content:   "Note Content",
      user_id:   @admin.id,
      client_id: @client.id
    }
  end

  test "index should be available to admins" do
    UserSession.create @admin
    get :index

    assert_not_empty assigns(:client_notes)
  end

  test "show should be available to admins" do
    UserSession.create @admin
    get :show, id: @client_note

    assert_equal @client_note, assigns(:client_note)
  end

  test "new should be available to admins" do
    UserSession.create @admin
    get :new

    assert_not_nil assigns(:client_note)
  end

  test "edit should be available to admins" do
    UserSession.create @admin
    get :edit, id: @client_note

    assert_equal @client_note, assigns(:client_note)
  end

  test "create should be available to admins" do
    client_note_count = ClientNote.count
    expected_client_note_count = client_note_count + 1
    UserSession.create @admin
    post :create, client_note: @attributes

    assert_equal expected_client_note_count, ClientNote.count
    assert_redirected_to ClientNote.last
  end

  test "update should be available to admins" do
    UserSession.create @admin
    put :update, { id: @client_note.to_param, client_note: { title: "Updated Title" } }

    assert_redirected_to @client_note
    assert_equal "Updated Title", @client_note.reload.title
  end

  test "delete should be available to admins" do
    client_note_count = ClientNote.count
    expected_client_note_count = client_note_count - 1
    UserSession.create @admin
    delete :destroy, id: @client_note

    assert_equal expected_client_note_count, ClientNote.count
    assert_redirected_to client_notes_url
  end

  # XXX: Skip converting silly tests that were just about using mocks
end
