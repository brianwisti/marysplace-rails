require 'spec_helper'

describe Checkin do
  let(:checkin) { create :checkin }

  it "should be unique per client per day" do
    dupe = Checkin.new do |ch|
      ch.user       = checkin.user
      ch.client     = checkin.client
      ch.checkin_at = checkin.checkin_at
    end

    expect(dupe).to have(1).errors_on(:client_id)
  end

  it "should have a Location" do
    placeless = Checkin.create do |ch|
      ch.user       = create(:user)
      ch.client     = create(:client)
      ch.checkin_at = checkin.checkin_at
    end

    expect(placeless).to have(1).errors_on(:location_id)
  end
end
