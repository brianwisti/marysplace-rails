require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test "message content is required" do
    empty_message = Message.new
    empty_message.valid?
    assert_equal empty_message.errors[:content].size, 1
  end
end
