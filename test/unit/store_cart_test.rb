require 'test_helper'

class StoreCartTest < ActiveSupport::TestCase
  setup do
    @user = users(:staff)
    @client = clients(:amy_a)
  end

  test "start" do
    assert StoreCart.respond_to?(:start),
      "StoreCart.start is the blessed way to start shopping"
    assert cart = StoreCart.start(@client, @user),
      "StoreCart.start is called with the shopper Client and the handler User"
    assert cart.started_at,
      "StoreCart.start sets started_at for the new cart."
    assert_equal 0, cart.total,
      "StoreCart.start sets total to zero for the new cart."
  end
end
