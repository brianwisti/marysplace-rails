require 'test_helper'

class PreferenceTest < ActiveSupport::TestCase
  def setup
    @user = users :simple
    @pref = Preference.new user: @user
  end

  test "should require user association" do
    pref = Preference.new
    pref.valid?

    assert_not_empty pref.errors[:user_id]
  end

  test "Default preferences for client fields" do
    defaults = Preference.default_for :client_fields

    assert_includes defaults, 'point_balance',
      "should contain point_balance"

    assert_includes defaults, 'created_at',
      "should contain created_at"
  end

  test "setting preferences accepts an array" do
    @pref.client_fields = [ 'point_balance' ]
    @pref.valid?

    assert_empty @pref.errors[:client_fields]
  end

  test "should require valid client attributes" do
    @pref.client_fields = %w{ waffle_house }
    @pref.valid?

    assert_not_empty @pref.errors[:client_fields]
  end
end
