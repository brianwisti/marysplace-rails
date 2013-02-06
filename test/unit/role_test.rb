require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "basic role validation" do
    role = Role.new
    role.valid?
    assert role.errors[:name].any?,
      "Role name must be present"
    role.name = "wafflemonger"
    role.valid?
    assert role.errors[:name].empty?
    role.save

    role_2 = Role.new(name: "wafflemonger")
    role_2.valid?
    assert role_2.errors[:name].any?,
      "Role name must be unique"
  end
end
