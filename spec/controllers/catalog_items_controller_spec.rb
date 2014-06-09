require 'spec_helper'

describe CatalogItemsController do
  setup :activate_authlogic

  context "anonymous access" do
    describe "index" do
      it "should be unavailable" do
        get :index
        expect_login response
      end
    end
  end

  context "admin access" do
    let(:admin_user) { create :admin_user }

    before do
      UserSession.create admin_user
    end

    describe "index" do
      it "should be available" do
        get :index
        expect(response).to be_success
      end
    end
  end
end
