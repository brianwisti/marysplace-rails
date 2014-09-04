require 'spec_helper'

describe PointsEntriesController do
  fixtures :clients, :users, :points_entries, :points_entry_types
  setup :activate_authlogic

  let(:entry) { points_entries :dishes }
  let(:attributes) do
    Hash.new.tap do |h|
      h[:added_by_id] = entry.added_by.id
      h[:client_id]  = entry.client.id
      h[:points_entry_type_id] = entry.points_entry_type.id
      h[:location_id] = entry.location.id
      h[:points_entered] = entry.points_entered
    end
  end

  describe "Anonymous user" do
    # require_user at top of controller means we don't need to test all
    # routes.
    it "cannot access this section" do
      get :index
      expect_login response
    end
  end

  describe "Staff user" do
    let(:staff_user) { users :staff_user }

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
      post :create, points_entry: attributes
      expect(response).to redirect_to(assigns(:points_entry))
    end

    context "creating a PointsEntry" do

      context "with client ID & entry-type ID" do
        it "creates a PointsEntry" do
          expect {
            post :create, points_entry: attributes
          }.to change(PointsEntry, :count).by(1)
        end
      end

      context "with client ID & entry-type ID & multiple" do
        let(:multiple)       { 3 }
        let(:points_entered) { 100 }
        let(:expected)       { points_entered * multiple }

        before do
          attributes[:multiple] = multiple
          attributes[:points_entered] = points_entered
        end

        it "creates a PointsEntry" do
          expect {
            post :create, points_entry: attributes
          }.to change(PointsEntry, :count).by(1)
        end

        it "applies the multiple" do
          post :create, points_entry: attributes
          new_entry = assigns(:points_entry)
          new_entry.points { should eq(expected) }
        end
      end

      context "with client name & entry-type ID" do
        let(:client) { clients :normal_client }

        it "creates a PointsEntry" do
          attributes.delete :client_id

          expect {
            post :create, points_entry: attributes, current_alias: client.current_alias
          }.to change(PointsEntry, :count).by(1)
        end
      end

      context "with client ID & entry-type name" do
        let(:entry_type) { points_entry_types :am_dishes }

        it "creates a PointsEntry" do
          attributes.delete :points_entry_type_id
          post :create, points_entry: attributes,
            points_entry_type: entry_type.name
          expect(flash[:notice]).to have_content("Points entry was successfully created")
        end
      end
    end

    it "can access update" do
      put :update, id: entry, points_entry: attributes
      expect(response).to redirect_to(entry)
    end

    it "can access destroy" do
      delete :destroy, id: entry
      expect(response).to redirect_to(points_entries_url)
    end

    it "can destroy a PointsEntry" do
      entry = points_entries :dishes

      expect {
        delete :destroy, id: entry
      }.to change(PointsEntry, :count).by(-1)
    end
  end
end
