require 'test_helper'
require 'pp'

class ClientTest < ActiveSupport::TestCase
  test "required fields" do
    c = Client.new
    c.valid?
    assert c.errors[:current_alias].any?,
      "current_alais is required"
    assert c.errors[:added_by_id].any?,
      "added_by_id is required"

    u = users(:admin)
    c.current_alias = "Amy"
    c.added_by_id = u.id
    c.valid?
    assert c.errors[:current_alias].empty?
    assert c.errors[:added_by_id].empty?
  end

  test "current_alias uniqueness" do
    amy = clients :amy_a
    admin = users :admin
    c = Client.new(current_alias: amy.current_alias,
                   added_by_id: admin.id)
    c.valid?
    assert c.errors[:current_alias].any?,
      "current_alias must be unique"
  end

  test "quicksearch" do
    results = Client.quicksearch("Amy A.")
    assert_equal 1, results.length,
      "can return an exact match"

    results = Client.quicksearch("Amy")
    assert_equal 3, results.length,
      "can return a case-insensitive substring match of active users"

    results = Client.quicksearch("Deborah")
    assert_equal 1, results.length,
      "can return match against other aliases"

    results = Client.quicksearch("Amy A. ")
    assert_equal 1, results.length,
      "is smart enough to ignore trailing spaces."
  end

  test "associated user account" do
    client = clients(:amy_a)
    password = "waffle"
    assert !client.login,
      "Client does not have a login until we create one."
    assert client.create_login(password: password, password_confirmation: password)
    assert client.login,
      "Client has a login after we create one."
  end

  test "flagging" do
    client = clients(:amy_a)
    user = users(:admin)
    assert_equal false, client.is_flagged
    flag = ClientFlag.create! client_id: client.id, created_by_id: user.id
    assert !flag.is_resolved?
    client.reload
    assert client.is_flagged,
      "Creation of a new flag is indicated in Client.is_flagged"
  end

  test "block from shopping" do
    client = clients(:amy_a)
    user = users(:admin)
    assert_equal true, client.can_shop?
    flag = ClientFlag.create! client_id: client.id, created_by_id: user.id, can_shop: false
    client.reload
    assert_equal false, client.can_shop?
  end

  test "Client#is_shopping? with no carts" do
    client = clients(:amy_a)
    assert_equal false, client.is_shopping?,
      "should be false"
  end

  test "Client#is_shopping? with a cart" do
    client = clients(:amy_a)
    user = users(:admin)
    cart = StoreCart.start(client, user)
    assert client.is_shopping?,
      "should be true"
  end
end
