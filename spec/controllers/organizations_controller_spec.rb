require 'rails_helper'

describe OrganizationsController, :type => :controller do
  setup :activate_authlogic
  let(:organization) { create :organization }

  describe "Site Admin User" do
    let(:user) { create :site_admin_user }

    before do
      login user
    end

    context "GET index" do
      before { get :index }

      it "is accessible" do
        expect(response).to be_success
      end
    end

    context "GET show" do
      before { get :show, id: organization }

      it "is accessible" do
        expect(response).to be_success
      end
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

      it "creates an Organization" do
        expect {
          post :create, organization: attributes_for(:organization)
        }.to change(Organization, :count).by(1)
      end
    end

    context "GET edit" do
      before { get :edit, id: organization }

      it "is accessible" do
        expect(response).to be_success
      end

      skip "loads the organization"
    end

    context "PUT update" do
      it "is accessible" do
        put :update, id: organization, organization: attributes_for(:organization)
        expect(response).to redirect_to(organization)
      end
    end

    context "DELETE destroy" do

      it "is accessible" do
        delete :destroy, id: organization
        expect(response).to redirect_to(organizations_url)
      end

      skip "destroys the organization" do
        expect {
          delete :destroy, id: organization
        }.to change(Organization, :count).by(-1)
      end
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
