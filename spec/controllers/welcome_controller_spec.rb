require 'spec_helper'

describe WelcomeController do
  context "Anonymous access" do
    it "should be redirected" do
      get :index
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end
