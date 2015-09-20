require 'rails_helper'

describe Checkin, type: :model do
  fixtures :checkins

  it "should be unique per client per location per day" do
    checkin = checkins :amy_a_overnight
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
      Checkin.destroy_all
      count = Checkin.today.count
      expect(count).to eql(0)
    end

    it "should note checkins made today" do
      count = Checkin.today.count
      expect(count).to eql(1)
    end
  end
end
