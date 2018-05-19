require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users :staff
  end

  test "should have a login" do
    user = User.new
    user.valid?

    assert_not_empty user.errors[:login]
  end

  test "should have a unique login" do
    first = users :simple
    dupe = User.new login: first.login
    dupe.valid?

    assert_not_empty dupe.errors[:login]
  end

  test "should know if it has a role" do
    role = roles :staff

    assert @user.role? role.name
  end

  test "should know if it does not have a role" do
    role = roles :volunteer
    
    assert_not @user.role? role.name
  end

  test "should be able to accept a role" do
    role = roles :volunteer
    @user.accept_role role

    assert @user.role? role.name
  end

  test "should be able to withdraw a role" do
    role = roles :staff
    @user.withdraw_role role

    assert_not @user.role? role.name
  end

  test "should be able to establish multiple roles" do
    specified_roles = [
      roles(:admin),
      roles(:staff),
      roles(:front_desk),
    ]
    simple_user = users :simple
    simple_user.establish_roles specified_roles

    assert simple_user.role? 'admin'
    assert simple_user.role? 'staff'
    assert simple_user.role? 'front_desk'
  end

  test "establishing multiple roles should remove roles not specified" do
    specified_roles = [
      roles(:admin),
      roles(:front_desk),
    ]
    @user.establish_roles specified_roles

    assert_not @user.role? 'staff'
  end

  test "preferences should use defaults if not set" do
    setting = :client_fields
    prefs = @user.preference_for setting
    defaults = Preference.default_for setting

    assert_equal prefs, defaults
  end

  test "should use saved preferences if set" do
    @user.remember_preference client_fields: %w{ point_balance }
    prefs = @user.preference_for :client_fields
    
    assert_includes prefs, 'point_balance'

    assert_not_includes prefs, 'created_at'
  end
end
