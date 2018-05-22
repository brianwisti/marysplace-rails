require 'test_helper'

class CheckinsControllerTest < ActionController::TestCase
  include Authlogic::TestCase

  setup :activate_authlogic

  def setup
    @user = users :simple
  end

end
