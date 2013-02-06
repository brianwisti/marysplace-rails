require 'test_helper'

class ClientFlagTest < ActiveSupport::TestCase
  setup do
    @client = clients(:amy_a)
    @user = users(:admin)
  end

  test "validation" do
    flag = ClientFlag.new
    flag.valid?
    assert flag.errors[:client].any?,
      "Client ID is required"
    assert flag.errors[:created_by].any?,
      "Creating user ID is required"
    flag.client = @client
    flag.created_by = @user
    flag.valid?
    assert flag.errors[:client].empty?
    assert flag.errors[:created_by].empty?
  end
end
