require 'test_helper'

class PointsEntryTest < ActiveSupport::TestCase
  test "validations" do
    entry = PointsEntry.new
    entry.valid?
    assert entry.errors[:client_id].any?,
      "Client is required"
    assert entry.errors[:points_entry_type_id].any?,
      "PointsEntryType is required"
    assert entry.errors[:points].any?,
      "points is/are required"
    assert entry.errors[:added_by_id].any?,
      "added by is required"
    entry.client = clients(:amy_a)
    entry.points_entry_type = points_entry_types(:dishes)
    entry.valid?
    assert entry.errors[:client_id].empty?
    assert entry.errors[:points_entry_type_id].empty?
  end

  test "after creation" do
    entry = PointsEntry.new
    entry.client = clients(:amy_a)
    entry.points_entry_type = points_entry_types(:am_chairs)
    entry.points = 50
    entry.added_by = users(:admin)
    assert entry.save
    assert_equal Date.today, entry.performed_on
  end

end
