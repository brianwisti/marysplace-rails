require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def setup
    @site_admin = users :site_admin
    @first = Organization.create! name: "First", creator: @site_admin
  end

  test "name must be present" do
    org = Organization.new
    org.valid?

    assert_not_empty org.errors[:name]
  end

  test "name must be unique" do
    org = Organization.new name: @first.name
    org.valid?

    assert_not_empty org.errors[:name]
  end

  test "creator must be present" do
    org = Organization.new
    org.valid?

    assert_not_empty org.errors[:creator_id]
  end
end
