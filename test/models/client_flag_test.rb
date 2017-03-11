require 'test_helper'

class ClientFlagTest < ActiveSupport::TestCase

  test "active count counts unresolved flags" do
    # TODO: maybe not rely on hard-coded fixtures for this specific test?
    assert_equal 2, ClientFlag.active_count
  end

  test "active count should be zero if no unresolved flags" do
    ClientFlag.destroy_all
    assert_equal 0, ClientFlag.active_count
  end
end
