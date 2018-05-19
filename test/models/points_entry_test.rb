require 'test_helper'

class PointsEntryTest < ActiveSupport::TestCase
  def setup
    @points_entry = points_entries :amy_a_day_shelter_dishes
  end

  test "should be added by a user" do
    entry = PointsEntry.create do |entry|
      entry.client            = @points_entry.client
      entry.points_entry_type = @points_entry.points_entry_type
      entry.points            = @points_entry.points
      entry.performed_on      = @points_entry.performed_on
    end

    assert_not_empty entry.errors[:added_by_id]
  end

  test "should have a location" do
    entry = PointsEntry.create do |entry|
      entry.client            = @points_entry.client
      entry.added_by          = @points_entry.added_by
      entry.points_entry_type = @points_entry.points_entry_type
      entry.points            = @points_entry.points
      entry.performed_on      = @points_entry.performed_on
    end

    assert_not_empty entry.errors[:location_id]
  end

  test "points multiple applied to a new entry requires points entered" do
    points = 100
    @points_entry.points_entered = nil
    @points_entry.points = points
    @points_entry.valid?

    assert_not_empty @points_entry.errors[:points_entered]
  end

  test "points updated when entry saved if new points are entered" do
    points = 75
    @points_entry.points_entered = points
    @points_entry.points = 0
    @points_entry.save

    assert_equal points, @points_entry.points
  end

  test "points multiple may be set" do
    points_entered = 50
    multiple = 2
    expected_points = points_entered * multiple
    @points_entry.update_attributes multiple: multiple, points_entered: points_entered
    @points_entry.save

    assert_equal expected_points, @points_entry.points
  end

  test "multiple should not apply to negative points entered" do
    @points_entry.update_attributes points: 0, multiple: 2, points_entered: -50

    assert_not_empty @points_entry.errors[:multiple]
  end

  test "multiple should not be negative" do
    @points_entry.update_attributes points: 0, multiple: -2, points_entered: 50

    assert_not_empty @points_entry.errors[:multiple]
  end

  test "updating multiple recalculates entry points" do
    multiple = 2
    expected_points = @points_entry.points_entered * multiple
    @points_entry.multiple = multiple
    @points_entry.save

    assert_equal expected_points, @points_entry.points
  end

  test "updating points_entered recalculates entry points" do
    points_entered = 25
    expected_points = points_entered * @points_entry.multiple
    @points_entry.points_entered = points_entered
    @points_entry.save

    assert_equal expected_points, @points_entry.points
  end

  test "daily_count should start at zero" do
    PointsEntry.destroy_all
    assert_equal 0, PointsEntry.daily_count
  end

  test "daily_count should reflect points entries added today" do
    # 2 currently in fixture were added today
    assert_equal 2, PointsEntry.daily_count
  end

  test "purchases scope" do
    purchase = points_entries :amy_a_day_shelter_purchase
    dishes = points_entries :amy_a_day_shelter_dishes

    assert_includes PointsEntry.purchases, purchase,
      "should include purchases"
    assert_not_includes PointsEntry.purchases, dishes,
      "should not include chores"
  end
end
