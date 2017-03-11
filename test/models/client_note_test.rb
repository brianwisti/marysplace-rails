require 'test_helper'

class ClientNoteTest < ActiveSupport::TestCase

  test "ClientNote requires content" do
    note = ClientNote.new
    note.valid?
    assert_equal note.errors[:content].size, 1
  end

  test "ClientNote requires a user" do
    note = ClientNote.new
    note.valid?
    assert_equal note.errors[:user].size, 1
  end

  test "ClientNote requires a client" do
    note = ClientNote.new
    note.valid?
    assert_equal note.errors[:client].size, 1
  end
end
