require 'test_helper'

class SignupListTest < ActiveSupport::TestCase
  setup do
    @entry_type = PointsEntryType.create(name: "Waffles",
                                         default_points: 10)
  end

  test "validation" do
    list = SignupList.new
    list.valid?
    assert list.errors[:points_entry_type_id].any?,
      "points_entry_type_id may not be null"
    list.points_entry_type = @entry_type
    list.valid?
    assert list.errors[:points_entry_type_id].empty?
  end
end
