require "spec_helper"

describe API::V0::CheckinsController, :type => :controller do
  setup :activate_authlogic

  skip "requires authentication" do
    get :index
    expect(response).to_not be_success
  end

  it "requires authorization"

  describe "POST /api/v0/checkins/create" do
    let(:staff_user) { create :staff_user }
    let(:client)     { create :client_with_badge }
    let(:location)   { create :location }

    before do
      login staff_user
    end

    it "can be accessed by staff" do
      post :create, format: :json,
        login: client.checkin_code,
        location_id: location.id
      expect(response).to be_success
    end

    it "creates a Checkin" do
      expect {
        post :create, format: :json,
          login: client.checkin_code,
          location_id: location.id
      }.to change(Checkin, :count).by(1)
    end

    it "returns the checkin as JSON" do
      post :create, format: :json,
        login: client.checkin_code,
        location_id: location.id
      expect(assigns(:checkin)).to_not be_nil
      checkin = assigns(:checkin)
      expected = {
        checkin: {
          id:         checkin.id,
          checkin_at: checkin.checkin_at,
          client: {
            current_alias: checkin.client.current_alias
          },
        }
      }.to_json
      expect(response.body).to eql(expected)
    end
  end
end
