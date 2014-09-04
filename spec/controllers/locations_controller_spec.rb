require 'spec_helper'

describe LocationsController do
  fixtures :locations, :users
  setup :activate_authlogic
  let(:location) { locations :prime }
  let(:attributes) { Hash.new.tap { |h| h[:name] = "Secundus" } }

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
      post :create, location: attributes
      expect_login response
    end

    it "cannot create a Location" do
      expect {
        post :create, location: attributes
      }.to change(Location, :count).by(0)
    end

    it "cannot access update" do
      put :update, id: location, location: attributes
      expect_login response
    end

    it "cannot access destroy" do
      delete :destroy, id: location
      expect_login response
    end

    it "cannot destroy a Checkin" do
      location = locations :prime
      expect {
        delete :destroy, id: location
      }.to change(Location, :count).by(0)
    end
  end

  describe "Staff user" do
    let(:user) { users :staff_user }

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
      post :create, location: attributes
      expect_forbidden response
    end

    it "cannot create a Location" do
      expect {
        post :create, location: attributes
      }.to change(Location, :count).by(0)
    end

    it "cannot access update" do
      put :update, id: location, location: attributes
      expect_forbidden response
    end

    it "cannot access destroy" do
      delete :destroy, id: location
      expect_forbidden response
    end

    it "cannot destroy a Location" do
      location = locations :prime
      expect {
        delete :destroy, id: location
      }.to change(Location, :count).by(0)
    end
  end

  describe "Admin user" do
    let(:admin_user) { users :admin_user }

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
      get :show, id: locations(:prime)
      expect(response).to render_template(:show)
    end

    it "sees a Location to show" do
      location = locations :prime
      get :show, id: location
      expect(assigns(:location)).to eql(location)
    end

    it "can access new" do
      get :new
      expect(response).to render_template(:new)
    end

    it "can access edit" do
      location = locations :prime
      get :edit, id: location
      expect(response).to render_template(:edit)
    end

    it "can access create" do
      post :create, location: attributes
      expect(response).to redirect_to(location_url(assigns(:location)))
    end

    it "can create a Location" do
      expect {
        post :create, location: attributes
      }.to change(Location, :count).by(1)
    end

    it "can access update" do
      location = locations :prime
      put :update, id: location, location: attributes
      expect(response).to redirect_to(location_url(location))
    end

    it "can access destroy" do
      location = locations :prime
      delete :destroy, id: location
      expect(response).to redirect_to(locations_url)
    end

    it "can destroy a Location" do
      location = locations :prime
      expect {
        delete :destroy, id: location
      }.to change(Location, :count).by(-1)
    end
  end
end
