require 'rails_helper'

describe PointsEntryTypesController, :type => :controller do
  setup :activate_authlogic
  fixtures :users, :points_entry_types

  let(:staff_user) { users :staff }
  let(:admin_user) { users :admin }
  let(:entry_type) { points_entry_types :dishes }

  describe "show" do
    before do
      login staff_user
    end

    it "should include entries of this type" do
      get :show, id: entry_type
      expect(assigns(:points_entries)).to_not be_nil
    end
  end

  describe "update" do
    before do
      @attributes = { description: "something something" }
      login admin_user
      patch :update, id: entry_type, points_entry_type: @attributes
    end

    it "updates the points entry type" do
      expect(entry_type.reload.description).to eql(@attributes[:description])
    end

    it "redirects to the points entry type after updating" do
      expect(response).to redirect_to(entry_type)
    end
  end

  describe "JSON" do
    context "GET /points_entry_types.json" do
      before do
        login staff_user
      end

      it "should have 2 items" do
        get :index, format: :json
        json = JSON.parse response.body
        expect(json.length).to eq(PointsEntryType.active.length)
      end
    end
  end
end
