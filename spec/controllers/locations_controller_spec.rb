require 'spec_helper'

describe LocationsController do
  setup :activate_authlogic
  let(:location) { create :location }

  describe "Anonymous user" do

    it "cannot access index" do
      get :index
      expect_login response
    end

    it "cannot access show" do
      get :show, id: location
      expect_login response
    end

    it "cannot access new" do
      get :new
      expect_login response
    end

    it "cannot access edit" do
      get :edit, id: location
      expect_login response
    end

    it "cannot access create" do
      post :create, location: attributes_for(:location)
      expect_login response
    end

    it "cannot create a Location" do
      expect {
        post :create, location: attributes_for(:location)
      }.to change(Location, :count).by(0)
    end

    it "cannot access update" do
      put :update, id: location, location: attributes_for(:location)
      expect_login response
    end

    it "cannot access destroy" do
      delete :destroy, id: location
      expect_login response
    end

    it "cannot destroy a Checkin" do
      location = create :location
      expect {
        delete :destroy, id: location
      }.to change(Location, :count).by(0)
    end
  end

  describe "Staff user" do
    let(:user) { create :staff_user }

    before do
      login user
    end

    it "can access index" do
      get :index
      expect(response).to be_success
    end

    it "can access show" do
      get :show, id: location
      expect(response).to be_success
    end

    it "cannot access new" do
      get :new
      expect_forbidden response
    end

    it "cannot access edit" do
      get :edit, id: location
      expect_forbidden response
    end

    it "cannot access create" do
      post :create, location: attributes_for(:location)
      expect_forbidden response
    end

    it "cannot create a Location" do
      expect {
        post :create, location: attributes_for(:location)
      }.to change(Location, :count).by(0)
    end

    it "cannot access update" do
      put :update, id: location, location: attributes_for(:location)
      expect_forbidden response
    end

    it "cannot access destroy" do
      delete :destroy, id: location
      expect_forbidden response
    end

    it "cannot destroy a Checkin" do
      location = create :location
      expect {
        delete :destroy, id: location
      }.to change(Location, :count).by(0)
    end
  end

  describe "Admin user" do
    let(:admin_user) { create :admin_user }

    before do
      login admin_user
    end

    it "can access index" do
      get :index
      expect(response).to render_template(:index)
    end

    it "sees some locations on index" do
      get :index
      expect(assigns(:locations)).to_not be_nil
    end

    it "can access show" do
      get :show, id: create(:location)
      expect(response).to render_template(:show)
    end

    it "sees a Location to show" do
      location = create(:location)
      get :show, id: location
      expect(assigns(:location)).to eql(location)
    end

    it "can access new" do
      get :new
      expect(response).to render_template(:new)
    end

    it "can access edit" do
      location = create(:location)
      get :edit, id: location
      expect(response).to render_template(:edit)
    end

    it "can access create" do
      post :create, location: attributes_for(:location)
      expect(response).to redirect_to(location_url(assigns(:location)))
    end

    it "can create a Location" do
      expect {
        post :create, location: attributes_for(:location)
      }.to change(Location, :count).by(1)
    end

    it "can access update" do
      location = create :location
      put :update, id: location, location: attributes_for(:location)
      expect(response).to redirect_to(location_url(location))
    end

    it "can access destroy" do
      location = create :location
      delete :destroy, id: location
      expect(response).to redirect_to(locations_url)
    end

    it "can destroy a Location" do
      location = create :location
      expect {
        delete :destroy, id: location
      }.to change(Location, :count).by(-1)
    end
  end
end
