require 'test_helper'

class CheckinTest < ActiveSupport::TestCase

  test "Allow only one daily checkin per client per location" do
    checkin = checkins :amy_a_overnight
    dupe = Checkin.new
    dupe.attributes = checkin.attributes
    dupe.valid?
    assert_equal dupe.errors[:client_id].size, 1
  end

  test "Checkins require a Location" do
    placeless = Checkin.new
    placeless.valid?
    assert_equal placeless.errors[:location_id].size, 1
  end

  test "daily checkin count" do
    assert_equal Checkin.today.count, 1
  end

end
