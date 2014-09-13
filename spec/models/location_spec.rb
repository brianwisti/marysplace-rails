require 'spec_helper'

describe Location, type: :model do
  describe "Name" do
    it "is required" do
      location = Location.new
      location.valid?
      expect(location.errors[:name].size).to eq(1)
    end

    it "must be unique" do
      first = FactoryGirl.create(:location)
      second = Location.new do |location|
        location.name = first.name
      end

      second.valid?
      expect(second.errors[:name].size).to eq(1)
    end
  end

  describe "default location for user" do
    let(:user) { create :staff_user }

    context "with no locations" do
      it "should be nothing" do
        loc = Location.default_location_for user
        expect(loc).to be_nil
      end
    end

    context "with one location and no points entries for the user" do
      it "should be the location" do
        loc = create :location
        result = Location.default_location_for user
        expect(result).to eq(loc)
      end
    end

    context "with two locations and no points entries for the user" do
      it "should be the first location" do
        # Create a new user to minimize noise from other specds
        new_user  = create :staff_user
        first     = create :location
        second    = create :location
        preferred = Location.order(:id).first
        result    = Location.default_location_for new_user

        expect(result).to eq(preferred)
      end
    end

    context "with two locations and a points entry for the user" do
      it "should be the location for the points entry" do
        first = create :location
        second = create :location
        entry = create :points_entry, added_by: user, location: second
        result = Location.default_location_for user
        expect(result).to eq(second)
      end
    end
  end
end
