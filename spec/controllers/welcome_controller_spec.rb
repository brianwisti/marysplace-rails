require 'spec_helper'

describe WelcomeController do
  fixtures :users
  setup :activate_authlogic

  context "Anonymous access" do
    it "should be redirected" do
      get :index
      expect_login response
    end
  end

  context "Admin Access" do
    let(:user) { users :admin_user }

    before do
      login user
    end

    it "should load the welcome page" do
      get :index
      expect(response).to_not redirect_to(new_user_session_url)
    end
  end
end
