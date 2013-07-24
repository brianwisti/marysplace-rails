require 'test_helper'

class StoreCartTest < ActiveSupport::TestCase
  setup do
    @user = users(:staff)
    @client = clients(:amy_a)
    @catalog_item = CatalogItem.create(name: "widget", cost: 50)
    @cart = StoreCart.start(@client, @user)
  end

  test "StoreCart.start" do
    assert StoreCart.respond_to?(:start),
      "StoreCart.start is the blessed way to start shopping"
    assert cart = StoreCart.start(@client, @user),
      "StoreCart.start is called with the shopper Client and the handler User"
    assert cart.started_at,
      "StoreCart.start sets started_at for the new cart."
    assert_equal 0, cart.total,
      "StoreCart.start sets total to zero for the new cart."
  end

  test "StoreCart#finish" do
    assert @cart.finish,
      "StoreCart#finish is the blessed way to wrap up shopping"
    @cart.reload
    assert @cart.finished_at,
      "StoreCart#finish sets finished_at for the finished cart."
  end

  test "StoreCart -> Client relation" do
    assert_equal @client, @cart.shopper,
      "Every StoreCart has a Client doing the shopping"
  end

  test "StoreCart -> User relation" do
    assert_equal @user, @cart.handled_by,
      "Every StoreCart has a User handling the Client's shopping"
  end

  test "StoreCart -> CartItem relation" do
    assert @cart.respond_to?(:items),
      "StoreCart#items holds the CartItems in this StoreCart"
  end

  test "Updated total on CartItem addition" do
    assert_equal 0, @cart.total,
      "Carts start with a total of zero points"
    @cart.items.create { |i| i.catalog_item = @catalog_item; i.cost = @catalog_item.cost }
    @cart.reload
    assert_equal @catalog_item.cost, @cart.total,
      "Cart total updates when an item is added"
  end

  test "Updated total on CartItem removal" do
    cart_item = StoreCartItem.create do |item|
      item.catalog_item  = @catalog_item
      item.cost          = @catalog_item.cost
      item.store_cart    = @cart
    end
    @cart.reload
    assert_equal @catalog_item.cost, @cart.total,
      "sanity check"
    cart_item.destroy
    @cart.reload
    assert_equal 0, @cart.total,
      "Cart total updates when an item is removed"
  end
end
