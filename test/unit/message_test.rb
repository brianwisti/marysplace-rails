require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  setup do
    @author = users(:admin)
    @attributes = {
      content: "This is a *test* message.",
      author_id: @author.id
    }
    @message = Message.new(@attributes)
  end

  test "content is required" do
    @message.content = nil
    assert !@message.valid?,
      "null content should be a validation error."
  end

  test "author_id is required" do
    @message.author_id = nil
    assert !@message.valid?,
      "null author should be a validation error."
  end

  test "author is a User" do
    assert @message.author,
      "messages have Authors"
    assert_equal @author, @message.author,
      "Confirm message author"
  end
end
