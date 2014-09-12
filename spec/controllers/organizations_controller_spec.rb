require 'spec_helper'

describe OrganizationsController do
  fixtures :organizations, :users

  setup :activate_authlogic

  let(:organization) { organizations :prime }

  let(:attributes) do
    attributes = Hash.new.tap do |h|
      h[:name] = "second"
      h[:creator] = users :site_admin_user
    end
  end

  describe "Site Admin User" do
    let(:user) { users :site_admin_user }

    before do
      login user
    end

    context "GET index" do
      it "is accessible" do
        admin = users :site_admin_user
        session = login admin
        p session
        get :index
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
        post :create, organization: attributes
        expect(response).to be_redirect
      end

      it "creates an Organization" do
        expect {
          post :create, organization: attributes
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
        put :update, id: organization, organization: attributes
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
    let(:user) { users :admin_user }

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
        post :create, organization: attributes
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
        put :update, id: organization, organization: attributes
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
