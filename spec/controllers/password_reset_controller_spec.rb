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
      before do
        post :create, { login: user.login }
      end

      it "succeeds" do
        expect(response.status).to eq(200)
      end

      it "loads a user" do
        expect(assigns(:user)).to_not be_nil
      end

      it "assigns a perishable token" do
        expect(assigns(:token)).to_not be_nil
      end
    end

    context ":edit" do
      before do
        user.reset_perishable_token!
        token = user.perishable_token
        get :edit, id: token
      end

      it "succeeds" do
        expect(response.status).to eq(200)
      end

      it "has no status message" do
        expect(flash[:notice]).to be_nil
      end
    end

    context ":update" do
      let(:password) { "waffle" }
      let(:submission) do { password: password, password_confirmation: password } end

      before do
        user.reset_perishable_token!
        token = user.perishable_token
        put :update, id: token, user: submission
      end

      it "redirects on success" do
        expect(response).to redirect_to(user)
      end

      it "notifies the user" do
        expect(flash[:notice]).to eq("Password successfully updated")
      end

      it "changes the password" do
        session = UserSession.new login: user.login, password: password
        expect(session).to_not be_nil
      end
    end
  end
end
