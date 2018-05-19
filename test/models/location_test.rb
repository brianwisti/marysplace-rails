require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @new_staff = users :new_staff
    @staff = users :staff
  end

  test "name is required" do
    location = Location.new
    location.valid?

    assert_not_empty location.errors[:name]
  end

  test "name should be unique" do
    first = locations :day_shelter
    second = Location.new do |location|
      location.name = first.name
    end
    second.valid?

    assert_not_empty second.errors[:name]
  end

  test "default user location is not set if no locations available" do
    Location.destroy_all
    loc = Location.default_location_for @new_staff

    assert_nil loc
  end

  test "oldest location is default if user has entered no points" do
    preferred = Location.order(:created_at).first
    result = Location.default_location_for @new_staff

    assert_equal preferred, result
  end

  test "location of user's last points entry logged is default" do
    expected = @staff.points_entries.last.location
    result = Location.default_location_for @staff
    assert_equal expected, result
  end
end
