require 'spec_helper'

describe Checkin do
  let(:checkin) { create :checkin }

  it "should be unique per client per location per day" do
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

  context "today" do
    it "should start at zero" do
      count = Checkin.today.count
      expect(count).to eql(0)
    end
    
    it "should note checkins made today" do
      create :checkin, checkin_at: DateTime.now
      count = Checkin.today.count
      expect(count).to eql(1)
    end
  end
end
