require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  setup :activate_authlogic

  setup do
    UserSession.create users(:admin)
  end

  test "should get show" do
    admin = roles(:admin)
    get :show, id: admin
    assert_response :success
  end
end
