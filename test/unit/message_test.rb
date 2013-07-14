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

  test "Content is required" do
    @message.content = nil
    assert !@message.valid?,
      "null content should be a validation error."
  end

  test "Author is required" do
    @message.author_id = nil
    assert !@message.valid?,
      "null author should be a validation error."
  end

end
