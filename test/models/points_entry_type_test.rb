require 'test_helper'

class PointsEntryTypeTest < ActiveSupport::TestCase
  def setup
    @entry_type = points_entry_types :boil_eggs
  end

  test "should have a name" do
    unnamed = PointsEntryType.new do |et|
      et.is_active = true
      et.default_points = 0
    end
    unnamed.valid?

    assert_not_empty unnamed.errors[:name]
  end

  test "should have a unique name" do
    dupe = PointsEntryType.new do |et|
      et.name = @entry_type.name
    end
    dupe.valid?

    assert_not_empty dupe.errors[:name]
  end

  test "active scope" do
    active = points_entry_types :boil_eggs
    inactive = points_entry_types :inactive_chore

    assert_includes PointsEntryType.active, active
    assert_not_includes PointsEntryType.active, inactive
  end

  test "purchase scope" do
    purchase = points_entry_types :purchase
    dishes = points_entry_types :dishes

    assert_includes PointsEntryType.purchase, purchase
    assert_not_includes PointsEntryType.purchase, dishes
  end

  test "quicksearch results should include exact matches" do
    am_bathroom = points_entry_types :am_bathroom
    results = PointsEntryType.quicksearch "AM Bathroom"

    assert_includes results, am_bathroom,
      "quicksearch 'AM Bathroom' returns am_bathroom points_entry_type"
    assert_equal 1, results.length,
      "... and nothing else"
  end

  test "quicksearch results should include case-insensitive substring matches" do
    results = PointsEntryType.quicksearch "bathroom"
    assert_equal 2, results.length
  end
end
