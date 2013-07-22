require 'test_helper'

class StoreCartTest < ActiveSupport::TestCase
  setup do
    @user = users(:staff)
    @client = clients(:amy_a)
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
end
