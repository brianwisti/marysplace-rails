require 'spec_helper'

describe PointsEntryTypesController do
  fixtures :users, :points_entry_types

  setup :activate_authlogic

  let(:staff_user) { users :staff_user }

  describe "JSON" do

    context "GET /points_entry_types.json" do
      it "should have items" do
        login staff_user
        get :index, format: :json
        json = JSON.parse response.body
        expect(json.length).to eq(PointsEntryType.active.length)
      end
    end
  end
end
