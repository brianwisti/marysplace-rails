require 'spec_helper'

describe PointsEntryTypesController do
  setup :activate_authlogic
  let(:staff_user) { create :staff_user }
  let(:admin_user) { create :admin_user }

  describe "show" do
    let(:entry_type) { create :points_entry_type }

    before do
      create :points_entry, points_entry_type: entry_type
      login staff_user
    end

    it "should include entries of this type" do
      get :show, id: entry_type
      expect(assigns(:points_entries)).to_not be_nil
    end
  end

  describe "update" do
    before do
      @entry_type = create :points_entry_type
      @attributes = { description: "something something" }
      login admin_user
      patch :update, id: @entry_type, points_entry_type: @attributes
    end

    it "updates the points entry type" do
      expect(@entry_type.reload.description).to eql(@attributes[:description])
    end

    it "redirects to the points entry type after updating" do
      expect(response).to redirect_to(@entry_type)
    end
  end

  describe "JSON" do
    context "GET /points_entry_types.json" do
      before do
        50.times { create :points_entry_type }
        login staff_user
      end

      it "should have 50 items" do
        get :index, format: :json
        json = JSON.parse response.body
        expect(json.length).to eq(50)
      end
    end
  end
end
