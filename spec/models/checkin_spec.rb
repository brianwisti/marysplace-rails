require 'rails_helper'

describe Checkin, type: :model do

  it "should be unique per client per location per day" do
    checkin = create :checkin
    dupe = Checkin.new
    dupe.attributes = checkin.attributes

    dupe.valid?
    expect(dupe.errors[:client_id].size).to eq(1)
  end

  it "should have a Location" do
    placeless = Checkin.new
    placeless.valid?
    expect(placeless.errors[:location_id].size).to eq(1)
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
