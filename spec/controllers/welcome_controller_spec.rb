require 'rails_helper'

describe WelcomeController, :type => :controller do
  setup :activate_authlogic
  fixtures :users

  context "Anonymous access" do
    it "should be redirected" do
      get :index
      expect_login response
    end
  end

  context "Admin Access" do
    let(:user) { users :admin }

    before do
      login user
    end

    after do
      logout user
    end

    it "should load the welcome page" do
      get :index
      expect(response).to_not redirect_to(new_user_session_url)
    end
  end
end
