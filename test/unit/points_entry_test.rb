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

  test "stringified summary" do
    entry = PointsEntry.new
    entry.client = clients(:amy_a)
    entry.points_entry_type = points_entry_types(:am_chairs)
    entry.points = 50
    entry.added_by = users(:admin)

    summary = entry.summarize
    assert_equal "#{entry.performed_on} #{entry.client.current_alias} #{entry.points_entry_type.name} #{entry.points}", summary
  end

  test "report span" do
    start = DateTime.new(2012, 1, 1)
    finish = DateTime.new(2012, 12, 1)
    assert_nil PointsEntry.report_for_span(start, finish, "minute")
    assert PointsEntry.report_for_span(start, finish, "month")
    assert PointsEntry.report_for_span(start, finish, "day")
  end

  test "monthly reports" do
    assert PointsEntry.per_month_in(2012)
  end

  test "daily reports" do
    assert PointsEntry.per_day_in(2012, 7)
  end

  test "block shopping after bail" do
    client = clients(:amy_a)
    entry_type = points_entry_types(:am_chairs)
    assert client.can_shop?
    entry = PointsEntry.new
    entry.client = client
    entry.points_entry_type = entry_type
    entry.points = -100
    entry.bailed = true
    entry.added_by = users(:admin)
    entry.save!
    client.reload
    assert !client.can_shop?,
      "No shopping for two weeks after a bail."
    flag = client.flags.last
    assert_equal "Bailed on #{entry_type.name} - #{entry.performed_on}", flag.description,
      "explain reason for this flag"
  end
end
