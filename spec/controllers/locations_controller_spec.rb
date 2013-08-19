require 'spec_helper'

describe LocationsController do
  setup :activate_authlogic

  describe "Anonymous user" do

    it "cannot access index" do
      get :index
      expect_login response
    end

    it "cannot access show"

    it "cannot access new"

    it "cannot access edit"

    it "cannot access create"

    it "cannot create a Location"

    it "cannot access update"

    it "cannot access destroy"

    it "cannot destroy a Checkin"
  end

  describe "Staff user" do
    it "can access index"

    it "can access show"

    it "cannot access new"

    it "cannot access edit"

    it "cannot access create"

    it "cannot create a Location"

    it "cannot access update"

    it "cannot access destroy"

    it "cannot destroy a Checkin"
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

    it "can access create"

    it "can create a Location"

    it "can access update"

    it "can access destroy"

    it "can destroy a Checkin"
  end
end
