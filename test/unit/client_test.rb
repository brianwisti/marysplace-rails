require 'test_helper'

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

end
