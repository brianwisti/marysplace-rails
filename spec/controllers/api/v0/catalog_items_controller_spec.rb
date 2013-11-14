require "spec_helper"

describe API::V0::CatalogItemsController do
  setup :activate_authlogic

  it "requires authentication"

  it "requires authorization"

  describe "GET /api/v0/checkins" do
    let(:staff_user) { create :staff_user }
    let(:item_1)     { create :catalog_item }

    before do
      login staff_user
    end

    it "can be accessed by staff" do
      get :index, format: :json
      expect(response).to be_success
    end
  end
end
