require 'test_helper'

class PreferenceTest < ActiveSupport::TestCase

  def setup
    @default = Preference.default_for :client_fields
  end

  test "preference requires a user" do
    pref = Preference.new
    pref.valid?
    assert_equal pref.errors[:user_id].size, 1
  end

  test "default includes point_balance" do
    assert_includes @default, 'point_balance'
  end

  test "default includes created_at" do
    assert_includes @default, 'created_at'
  end

  test "Preference initialized w/array of valid client attributes" do
    pref = Preference.new client_fields: [ 'point_balance' ]
    pref.valid?
    assert_equal pref.errors[:client_fields].size, 0
  end

  test "Preference client fields must be valid" do
    pref = Preference.new client_fields: [ 'waffle_house' ]
    pref.valid?
    assert_equal pref.errors[:client_fields].size, 1
  end

end
