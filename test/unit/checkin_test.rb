require 'test_helper'

class CheckinTest < ActiveSupport::TestCase
  
  test "one checkin per client per day" do
    user = users(:front_desk)
    client = clients(:amanda_b)
    at = DateTime.now
    attributes = {
      user_id: user.id,
      client_id: client.id,
      checkin_at: at
    }
    Checkin.create!(attributes)
    dupe = Checkin.new(attributes)
    assert dupe.invalid?
    assert dupe.errors[:client_id].include?("already checked in")
  end
end
