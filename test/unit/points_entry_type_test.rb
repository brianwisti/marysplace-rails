require 'test_helper'

class PointsEntryTypeTest < ActiveSupport::TestCase
  test "validation" do
    e = PointsEntryType.new
    e.valid?
    assert e.errors[:name].any?,
      "name may not be null."
    e.name = "Make Waffles"
    e.valid?
    assert e.errors[:name].empty?

    f = PointsEntryType.new
    f.name = points_entry_types(:dishes).name
    f.valid?
    assert f.errors[:name].any?,
      "name must be unique"
  end

  test "quicksearch" do
    results = PointsEntryType.quicksearch("AM Bathroom")
    assert_equal 1, results.length,
      "can return an exact match"

    results = PointsEntryType.quicksearch("sweep")
    assert_equal 3, results.length,
      "can return a case-insensitive substring match"
  end
end
