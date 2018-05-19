require 'test_helper'

class ClientFlagTest < ActiveSupport::TestCase
  test "active count starts at zero" do
    ClientFlag.destroy_all
    assert_equal 0, ClientFlag.active_count
  end

  test "active count includes unresolved flags" do
    assert_equal 2, ClientFlag.active_count
  end
end
