require 'test_helper'

class ClientNoteTest < ActiveSupport::TestCase
  def setup
    @client = clients :anna_a
    @user_staff = users :staff

    # for those tests that should maybe be functional
    @purchase_type = points_entry_types :purchase
    @day_shelter = locations :day_shelter
  end

  test "current alias must be present" do
    client = Client.new
    client.valid?

    assert_not_empty client.errors[:current_alias]
  end

  test "current alias must be unique" do
    dupe = Client.new current_alias: @client.current_alias
    dupe.valid?

    assert_not_empty dupe.errors[:current_alias]
  end

  test "user must be specified" do
    client = Client.new
    client.valid?
    assert_not_empty client.errors[:added_by_id]
  end

  test "organization should match user org if present" do
    @client.save!
    @client.reload
    assert_equal @user_staff.organization,
      @client.organization
  end

  test "quicksearch should return a case-insensitive substring match of active clients" do
    results = Client.quicksearch "Amy"
    assert_equal 3, results.length
  end

  test "quicksearch should find current_alias exact matches" do
    results = Client.quicksearch "Amy A."
    assert_equal 1, results.length
  end

  test "quicksearch should match against other_aliases" do
    results = Client.quicksearch "Deborah"
    assert_equal 1, results.length
  end

  test "checkin system starts uninitialized" do
    assert_nil @client.checkin_code
  end

  test "checkin system is set on request" do
    @client.update_checkin_code!
    assert_not_nil @client.checkin_code
  end

  test "should know if not flagged" do
    assert_not @client.is_flagged?
  end

  test "should know if flagged" do
    flag = ClientFlag.create do |f|
      f.created_by = @user_staff
      f.client     = @client
      f.can_shop   = false
    end

    assert @client.is_flagged?
  end

  test "an unflagged client can shop" do
    assert @client.can_shop?
  end

  # Maybe these should be integration tests?
  test "shopping visits record purchase points entries" do
    PointsEntry.create do |entry|
      entry.client            = @client
      entry.added_by          = @user_staff
      entry.points_entry_type = @purchase_type
      entry.location          = @day_shelter
    end

    @client.reload

    assert @client.has_shopped?
  end

  test "should remember last shopping visit" do
    entry = @client.points_entries.create! do |entry|
      entry.points_entry_type = @purchase_type
      entry.added_by          = @user_staff
      entry.points            = -100
      entry.performed_on      = Date.today
      entry.location          = @day_shelter
    end

    @client.reload
    assert_equal entry.performed_on.to_time.to_i,
      @client.last_shopped_at.to_i
  end

end
