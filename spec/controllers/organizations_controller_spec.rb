require 'spec_helper'

describe OrganizationsController do
  setup :activate_authlogic
  let(:organization) { create :organization }

  describe "Site Admin User" do
    let(:user) { create :site_admin_user }

    before do
      UserSession.create user
    end

    context "GET index" do
      before { get :index }

      it "is accessible" do
        expect(response).to be_success
      end

      pending "shows the Organizations"
    end

    context "GET show" do
      before { get :show, id: organization }

      it "is accessible" do
        expect(response).to be_success
      end

      pending "shows the Organization"
    end

    context "GET new" do
      before { get :new }

      it "is accessible" do
        expect(response).to be_success
      end
    end

    context "POST create" do
      it "is accessible" do
        post :create, organization: attributes_for(:organization)
        expect(response).to be_redirect
      end

      pending "creates an Organization"
    end

    context "GET edit" do
      before { get :edit, id: organization }

      it "is accessible" do
        expect(response).to be_success
      end

      pending "loads the organization"
    end

    context "PUT update" do
      it "is accessible" do
        put :update, id: organization, organization: attributes_for(:organization)
        expect(response).to be_redirect
      end

      pending "updates the organization"
    end

    context "DELETE destroy" do
      before { delete :destroy, id: organization }

      it "is accessible" do
        expect(response).to redirect_to(organizations_url)
      end

      pending "destroys the organization"
    end
  end

  describe "Admin User" do
    let(:user) { create :admin_user }

    before do
      UserSession.create user
    end

    context "GET index" do
      before { get :index }

      it "is not accessible" do
        expect_forbidden response
      end
    end

    context "GET show" do
      before { get :show, id: organization }

      it "is not accessible" do
        expect_forbidden response
      end
    end

    context "GET new" do
      before { get :new }

      it "is not accessible" do
        expect_forbidden response
      end
    end

    context "POST create" do
      it "is not accessible" do
        post :create, organization: attributes_for(:organization)
        expect_forbidden response
      end
    end

    context "GET edit" do
      before { get :edit, id: organization }

      it "is not accessible" do
        expect_forbidden response
      end
    end

    context "PUT update" do
      it "is not accessible" do
        put :update, id: organization, organization: attributes_for(:organization)
        expect_forbidden response
      end
    end

    context "DELETE destroy" do
      before { delete :destroy, id: organization }

      it "is not accessible" do
        expect_forbidden response
      end
    end
  end
end
