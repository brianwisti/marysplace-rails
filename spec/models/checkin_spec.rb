require 'spec_helper'

describe Checkin, type: :model do
  fixtures :checkins, :clients, :locations, :users
  let(:checkin) { checkins :first }

  it "should be unique per client per location per day" do
    dupe = Checkin.new do |ch|
      ch.user       = checkin.user
      ch.client     = checkin.client
      ch.checkin_at = checkin.checkin_at
    end

    dupe.valid?
    expect(dupe.errors[:client_id].size).to eq(1)
  end

  it "should have a Location" do
    placeless = Checkin.create do |ch|
      ch.user       = users :staff_user
      ch.client     = clients :normal_client
      ch.checkin_at = checkin.checkin_at
    end

    placeless.valid?
    expect(placeless.errors[:location_id].size).to eq(1)
  end

  context "today" do
    it "should start at zero" do
      count = Checkin.today.count
      expect(count).to eql(0)
    end

    it "should note checkins made today" do
      checkin = Checkin.create! do |ch|
        ch.user       = users :staff_user
        ch.client     = clients :normal_client
        ch.checkin_at = DateTime.now
        ch.location   = locations :prime
      end
      count = Checkin.today.count
      expect(count).to eql(1)
    end
  end
end
