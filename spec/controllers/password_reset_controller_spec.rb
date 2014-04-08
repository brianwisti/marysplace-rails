require 'spec_helper'

describe PasswordResetsController do
  setup :activate_authlogic
  let(:user) { create :user }

  context "Anonymous user" do
    context ":new" do
      it "loads successfully for anonymous" do
        get :new
        expect(response.status).to eq(200)
      end
    end

    context ":create" do
      it "succeeds" do
        post :create, { login: user.login }
        expect(response).to be_redirect
      end
    end
  end
end
