require 'spec_helper'

describe PointsEntryTypesController do
  setup :activate_authlogic
  let(:staff_user) { create :staff_user }

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
