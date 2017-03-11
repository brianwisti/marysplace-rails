require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def setup
    @the_place = organizations :the_place
  end

  test "organization requires a name" do
    org = Organization.new
    org.valid?
    assert_equal org.errors[:name].size, 1
  end

  test "organization name must be unique" do
    dupe = Organization.new name: @the_place.name
    dupe.valid?
    assert_equal dupe.errors[:name].size, 1
  end

  test "orgnization requires a creator" do
    org = Organization.new
    org.valid?
    assert_equal org.errors[:creator_id].size, 1
  end
end
