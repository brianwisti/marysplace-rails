require 'test_helper'

class PointsEntryTypeTest < ActiveSupport::TestCase
  def setup
    @entry_type = points_entry_types :boil_eggs
  end

  test "points entry type requires a name" do
    unnamed = PointsEntryType.new
    unnamed.valid?
    assert_equal unnamed.errors[:name].size, 1
  end

  test "points entry type name must be unique" do
    dupe = PointsEntryType.new name: @entry_type.name
    dupe.valid?
    assert_equal dupe.errors[:name].size, 1
  end

  test "active scope includes active entry types" do
    assert_includes PointsEntryType.active, points_entry_types(:boil_eggs)
  end

  test "active scope does not include inactive entry types" do
    refute_includes PointsEntryType.active, points_entry_types(:inactive_chore)
  end

  test "purchase scope includes the type named 'Purchase'" do
    assert_includes PointsEntryType.purchase, points_entry_types(:purchase)
    assert_equal PointsEntryType.purchase.size, 1
  end

  test "quicksearch can return an exact match" do
    results = PointsEntryType.quicksearch "AM Bathroom"
    assert_equal results.length, 1
  end

  test "quicksearch can return a case-insensitive substring match" do
    results = PointsEntryType.quicksearch "bathroom"
    assert_equal results.length, 2
  end
end
