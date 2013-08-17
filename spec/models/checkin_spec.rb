require 'spec_helper'

describe Checkin do
  before(:all) do
    @checkin = FactoryGirl.create(:checkin)
  end

  it "should be unique per client per day" do
    dupe = Checkin.new do |ch|
      ch.user       = @checkin.user
      ch.client     = @checkin.client
      ch.checkin_at = @checkin.checkin_at
    end

    expect(dupe).to have(1).errors_on(:client_id)
  end

  it "should have a Location" do
    checkin = Checkin.create do |ch|
      ch.user       = FactoryGirl.create(:user)
      ch.client     = FactoryGirl.create(:client)
      ch.checkin_at = @checkin.checkin_at
    end

    expect(checkin).to have(1).errors_on(:location_id)
  end
end
