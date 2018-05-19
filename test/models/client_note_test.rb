require 'test_helper'

class ClientNoteTest < ActiveSupport::TestCase
  test "should be invalid without content" do
    note = ClientNote.new
    note.valid?

    assert_not_empty note.errors[:content]
  end

  test "should be valid with content" do
    note = ClientNote.new content: "Stuff and things"
    note.valid?
    assert_empty note.errors[:content]
  end

  test "should be invalid without user" do
    note = ClientNote.new
    note.valid?

    assert_not_empty note.errors[:user]
  end

  test "should be valid with valid user" do
    user = users :simple
    note = ClientNote.new user: user
    note.valid?
    assert_empty note.errors[:user]
  end

  test "should be invalid without client" do
    note = ClientNote.new
    note.valid?
    assert_not_empty note.errors[:client]
  end

  test "should be valid with client" do
    client = clients :amy_a
    note = ClientNote.new client: client
    note.valid?
    assert_empty note.errors[:client]
  end
end
