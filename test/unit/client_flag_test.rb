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

  test "is_resolved check" do
    today = Date.today
    flag = ClientFlag.new client_id: @client.id, created_by_id: @user.id
    assert !flag.is_resolved?,
      "Newly created flag is unresolved"
    flag.resolved_on = today
    assert flag.is_resolved?,
      "Resolved flag is resolved"
    flag.resolved_on = nil
    assert !flag.is_resolved?,
      "Clearing resolved_on restores is_resolved? falsiness"
    flag.expires_on = today
    assert flag.is_resolved?,
      "Expired flag is resolved"
  end
end
