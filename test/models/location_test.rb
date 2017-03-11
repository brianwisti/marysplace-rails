require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @staff = users :staff
    @new_staff = users :new_staff
  end

  test "location requires a name" do
    location = Location.new
    location.valid?
    assert_equal location.errors[:name].size, 1
  end

  test "location name must be unique" do
    day_shelter = locations :day_shelter
    dupe = Location.new do |location|
      location.name = day_shelter.name
    end

    dupe.valid?
    assert_equal dupe.errors[:name].size, 1
  end

  test "default user location is nil if no locations" do
    Location.destroy_all
    location = Location.default_location_for @new_staff
    assert_nil location
  end

  test "last location used is default location for most users" do
    last_location = @staff.points_entries.last.location
    # NOTE: spec requests default for @new_staff. Why'd I do that?
    default = Location.default_location_for @staff
    assert_equal default, last_location
  end

  test "first location is default location for new users" do
    expected = Location.order(:created_at).first
    default = Location.default_location_for @new_staff
    assert_equal default, expected
  end
end
