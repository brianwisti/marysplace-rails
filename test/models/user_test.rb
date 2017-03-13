require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @front_desk = users :front_desk
    @user = users :simple
    @front_desk_role = roles :front_desk
    @admin_role = roles :admin
    @staff_role = roles :staff
  end

  test "User login is required" do
    user = User.new
    user.valid?
    refute_empty user.errors[:login]
  end

  test "User login must be unique" do
    user = User.new login: @user.login
    user.valid?
    refute_empty user.errors[:login]
  end

  # NOTE: Wherefore did I use name? Seems tacky
  test "user.role? is true if user has given role" do
    assert @front_desk.role? @front_desk_role.name
  end

  test "user.role? is false if user does not have given role" do
    refute @user.role? @front_desk_role.name
  end

  test "A user can accept a new role" do
    @user.accept_role @front_desk_role
    assert @user.role? @front_desk_role.name
  end

  test "A user can withdraw a role" do
    @front_desk.withdraw_role @front_desk_role
    refute @front_desk.role? @front_desk_role.name
  end

  test "A user can accept multiple roles" do
    roles = [ @admin_role, @front_desk_role, @staff_role ]
    @user.establish_roles roles
    roles.each { |r| assert @user.role? r.name }
  end

  test "established roles replace existing user roles" do
    roles = [ @admin_role, @front_desk_role, @staff_role ]
    non_admin_roles = roles - [ @admin_role ]
    @user.establish_roles non_admin_roles
    refute @user.role? @admin_role.name
  end

  test "User preference is default if not set" do
    assert_equal @user.preference_for(:client_fields), Preference.default_for(:client_fields)
  end

  test "User can remember specific preferences" do
    @user.remember_preference client_fields: [ 'point_balance' ]
    prefs = @user.preference_for :client_fields
    assert_includes prefs, 'point_balance'
    refute_includes prefs, 'created_at'
  end
end
