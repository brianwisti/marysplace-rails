require 'spec_helper'

describe Location do
  describe "Name" do
    it "is required" do
      location = Location.new
      expect(location).to have(1).errors_on(:name)
    end

    it "must be unique" do
      first = FactoryGirl.create(:location)
      second = Location.new do |location|
        location.name = first.name
      end

      expect(second).to have(1).errors_on(:name)
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
        first = create :location
        second = create :location
        result = Location.default_location_for user
        expect(result).to eq(first)
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
