require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @amy_a = clients :amy_a # a shopper
    @amy_c = clients :amy_c # bailed on a chore
    @anna_a = clients :anna_a # a blank slate
    @staff = users :staff
  end

  test "Client requires a current alias" do
    client = Client.new
    client.valid?
    assert_equal client.errors[:current_alias].size, 1
  end

  test "Client current alias must be unique" do
    dupe = Client.new(current_alias: @anna_a.current_alias)
    dupe.valid?
    assert_equal dupe.errors[:current_alias].size, 1
  end

  test "Client must be added by a User" do
    client = Client.new
    client.valid?
    assert_equal client.errors[:added_by_id].size, 1
  end

  test "Client Organization matches added_by org if available" do
    # Save because it's associated with a save hook
    @anna_a.save!
    @anna_a.reload
    assert_equal @anna_a.organization, @staff.organization
  end

  test "quicksearch returns a case-insensitive substring match of active Clients" do
    results = Client.quicksearch "Amy"
    assert_equal results.length, 3
  end

  test "quicksearch finds exact matches against current_alias" do
    results = Client.quicksearch "Amy A."
    assert_equal results.length, 1
  end

  test "quicksearch matches against client other aliases" do
    results = Client.quicksearch "Deborah"
    assert_equal results.length, 1
  end

  test "checkin code starts uninitialized" do
    # Saving just in case I threw some surprise save hook somewhere
    @anna_a.save!
    @anna_a.reload
    assert_nil @anna_a.checkin_code
  end

  test "checkin code is automatically set on request" do
    @anna_a.update_checkin_code!
    refute_nil @anna_a.checkin_code
  end

  test "a client knows when they have no unresolved flags" do
    refute @anna_a.is_flagged?
  end

  test "a client knows when they have unresolved flags" do
    assert @amy_c.is_flagged?
  end

  test "an unflagged client can shop" do
    assert @anna_a.can_shop?
  end

  test "a flagged client cannot shop" do
    refute @amy_c.can_shop?
  end

  test "a client knows when they've shopped" do
    assert @amy_a.has_shopped?
  end

  test "a client remembers they're last shopping visit" do
    entry = points_entries :amy_a_day_shelter_purchase
    assert_equal @amy_a.last_shopped_at, entry.performed_on.to_time
  end
end
