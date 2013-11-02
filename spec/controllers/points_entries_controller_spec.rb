require 'spec_helper'

describe PointsEntriesController do
  setup :activate_authlogic

  let(:entry) { create :points_entry }

  describe "Anonymous user" do
    # require_user at top of controller means we don't need to test all 
    # routes.
    it "cannot access this section" do
      get :index
      expect_login response
    end
  end

  describe "Staff user" do
    let(:staff_user) { create :staff_user }

    before do
      login staff_user
    end

    it "can access index" do
      get :index
      expect(response).to render_template(:index)
    end

    it "can see PointsEntries on index" do
      get :index
      expect(assigns(:points_entries)).to_not be_nil
    end

    it "can access show" do
      get :show, id: entry
      expect(response).to render_template(:show)
    end

    it "can see a PointsEntry on show" do
      get :show, id: entry
      expect(assigns(:points_entry)).to eql(entry)
    end

    it "can access new" do
      get :new
      expect(response).to render_template(:new)
    end

    it "can access edit" do
      get :edit, id: entry
      expect(response).to render_template(:edit)
    end

    it "sees a PointsEntry to edit" do
      get :edit, id: entry
      expect(assigns(:points_entry)).to eql(entry)
    end

    it "can access create" do
      post :create, points_entry: build_attributes(:points_entry)
      expect(response).to redirect_to(assigns(:points_entry))
    end

    it "can create a PointsEntry" do
      expect {
        post :create, points_entry: build_attributes(:points_entry)
      }.to change(PointsEntry, :count).by(1)
    end

    it "can access update" do
      put :update, id: entry,
        points_entry: attributes_for(:points_entry)
      expect(response).to redirect_to(entry)
    end

    it "can access destroy" do
      delete :destroy, id: entry
      expect(response).to redirect_to(points_entries_url)
    end

    it "can destroy a PointsEntry" do
      entry = create :points_entry

      expect {
        delete :destroy, id: entry
      }.to change(PointsEntry, :count).by(-1)
    end
  end
end
