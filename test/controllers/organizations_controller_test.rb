require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  include Authlogic::TestCase
  setup :activate_authlogic

  def setup
    @admin = users :admin
    @site_admin = users :site_admin
    @organization = organizations :the_place
    @attributes = {
      name: "The Other Place"
    }
  end

  test "site admin can access index" do
    UserSession.create @site_admin
    get :index

    assert_response :success
  end

end
