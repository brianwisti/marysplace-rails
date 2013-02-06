require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "login can't be empty" do
    u = User.new
    u.valid?
    assert u.errors[:login].any?
    u.login = "ted"
    u.valid?
    assert u.errors[:login].empty?
  end
  
  test "Finding roles" do
    u = users(:admin)
    assert u.role?(:admin),
      "admin is an admin"
    assert !u.role?(:volunteer),
      "admin is not a volunteer"
  end

end
