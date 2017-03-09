require 'rails_helper'

describe PointsEntriesController, :type => :controller do
  setup :activate_authlogic
  fixtures :clients, :users, :locations, :points_entries, :points_entry_types

  before do
    @staff_user = users :staff
    @attributes = {
      client_id:            clients(:amy_a),
      points_entry_type_id: points_entry_types(:boil_eggs),
      location_id:          locations(:overnight),
      performed_on:      Date.today,
      points_entered:    25,
      multiple:          1,
      points:            25,
    }
  end

  let(:entry) { points_entries :amy_a_day_shelter_dishes }

  describe "Anonymous user" do
    # require_user at top of controller means we don't need to test all
    # routes.
    it "cannot access this section" do
      get :index
      expect_login response
    end
  end

  describe "Staff user" do

    before do
      login @staff_user
    end

    after do
      logout @staff_user
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
      post :create, points_entry: @attributes
      expect(response).to redirect_to(assigns(:points_entry))
    end

    context "creating a PointsEntry" do
      let(:submission) { @attributes }

      context "with client ID & entry-type ID" do
        it "creates a PointsEntry" do
          expect {
            post :create, points_entry: submission
          }.to change(PointsEntry, :count).by(1)
        end
      end

      context "with client ID & entry-type ID & multiple" do
        let(:multiple)       { 3 }
        let(:points_entered) { 100 }
        let(:expected)       { points_entered * multiple }

        before do
          submission[:multiple] = multiple
          submission[:points_entered] = points_entered
        end

        it "creates a PointsEntry" do
          expect {
            post :create, points_entry: submission
          }.to change(PointsEntry, :count).by(1)
        end

        it "applies the multiple" do
          post :create, points_entry: submission
          new_entry = assigns(:points_entry)
          new_entry.points { is_expected.to eq(expected) }
        end
      end

      context "with client name & entry-type ID" do
        let(:client) { clients :amy_b }

        it "creates a PointsEntry" do
          submission.delete :client_id

          expect {
            post :create, points_entry: submission, current_alias: client.current_alias
          }.to change(PointsEntry, :count).by(1)
        end
      end

      context "with client ID & entry-type name" do
        let(:entry_type) { points_entry_types :dishes }

        it "creates a PointsEntry" do
          submission.delete :points_entry_type_id
          expect {
            post :create, points_entry: submission,
              points_entry_type: entry_type.name
          }.to change(PointsEntry, :count).by(1)
        end
      end
    end

    it "can access update" do
      put :update, id: entry,
        points_entry: @attributes
      expect(response).to redirect_to(entry)
    end

    it "can access destroy" do
      delete :destroy, id: entry
      expect(response).to redirect_to(points_entries_url)
    end

    it "can destroy a PointsEntry" do
      expect {
        delete :destroy, id: entry
      }.to change(PointsEntry, :count).by(-1)
    end
  end
end
