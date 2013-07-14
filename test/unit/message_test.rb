require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  setup do
    @author = users(:admin)
    @attributes = {
      content: "This is a *test* message.",
      author_id: @author.id
    }
  end

  test "Content is required" do
    message = Message.new(@attributes)
    message.content = nil
    assert !message.valid?,
      "null content should be a validation error."
  end

end
