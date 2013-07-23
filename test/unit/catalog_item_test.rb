require 'test_helper'

class CatalogItemTest < ActiveSupport::TestCase
  setup do
    @user = users(:admin)
    @item = CatalogItem.new do |item|
      item.name = "General 1000"
      item.cost = 1000
      item.added_by = @user
    end
  end

  test "added_by -> user connection" do
    assert_equal @user, @item.added_by
  end

end
