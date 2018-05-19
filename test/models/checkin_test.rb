require 'test_helper'

class CheckinTest < ActiveSupport::TestCase
  test "should be unique per client per location per day" do
    checkin = checkins :amy_a_overnight
    dupe = Checkin.new
    dupe.attributes = checkin.attributes
    dupe.valid?

    assert_not_empty dupe.errors[:client_id]
  end

  test "should have a Location" do
    placeless = Checkin.new
    placeless.valid?

    assert_not_empty placeless.errors[:location_id]
  end

  test "today's checkin count should start at zero" do
    Checkin.destroy_all
    count = Checkin.today.count

    assert_equal 0, count
  end

  test "today's checkin count should note checkins made today" do
    assert_equal 1, Checkin.today.count
  end
end
