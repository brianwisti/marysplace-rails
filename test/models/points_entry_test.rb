require 'test_helper'

class PointsEntryTest < ActiveSupport::TestCase
  def setup
    @entry = points_entries :amy_a_day_shelter_dishes
  end

  test "points entry requires a user" do
    entry = PointsEntry.new
    entry.valid?
    assert_equal entry.errors[:added_by_id].size, 1
  end

  test "points entry requires a location" do
    entry = PointsEntry.new
    entry.valid?
    assert_equal entry.errors[:location_id].size, 1
  end

  test "points entry requires points_entered" do
    @entry.points_entered = nil
    @entry.valid?
    assert_equal @entry.errors[:points_entered].size, 1
  end

  test "points are set when entry is saved" do
    points_entered = @entry.points + 50 # arbitrary new value
    @entry.update_attributes points: 0, points_entered: points_entered
    @entry.save
    assert_equal @entry.points, @entry.points_entered
  end

  test "points are based on points_entered and multiple" do
    points_entered = @entry.points_entered + 50 # arbitrary new value
    multiple = 2
    expected_points = points_entered * multiple
    @entry.update_attributes multiple: multiple, points_entered: points_entered
    @entry.save
    assert_equal @entry.points, expected_points
  end

  test "multiple is not applied for negative points entered" do
    @entry.update_attributes multiple: 2, points_entered: -50
    assert_equal @entry.errors[:multiple].size, 1
  end

  test "multiple cannot be negative" do
    @entry.update_attributes points: 0, multiple: -2, points_entered: 50
    assert_equal @entry.errors[:multiple].size, 1
  end

  test "updating multiple updates points" do
    multiple = @entry.multiple + 1
    expected_points = @entry.points_entered * multiple
    @entry.update_attributes multiple: multiple
    assert_equal @entry.points, expected_points
  end

  test "daily count reflects points entries made today" do
    assert_equal PointsEntry.daily_count, 2
  end

  test "purchase scope includes purchases" do
    assert_includes PointsEntry.purchases, points_entries(:amy_a_day_shelter_purchase)
  end

  test "purchase scope does not include chores" do
    refute_includes PointsEntry.purchases, points_entries(:amy_a_day_shelter_dishes)
  end
end
