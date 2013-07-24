require 'test_helper'

class StoreCartItemTest < ActiveSupport::TestCase
  setup do
    @cart = StoreCart.start(clients(:amy_a), users(:admin))
    @catalog_item = catalog_items(:general)
    @cart_item = StoreCartItem.new do |item|
      item.catalog_item = @catalog_item
      item.store_cart = @cart
    end
  end

  test "Catalog Item connection" do
    assert_equal @catalog_item, @cart_item.catalog_item
  end

  test "Store Cart connection" do
    assert_equal @cart, @cart_item.store_cart
  end
end
