require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test "content must be present" do
    empty_msg = Message.new
    empty_msg.valid?

    assert_not_empty empty_msg.errors[:content]
  end
end
