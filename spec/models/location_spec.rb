require 'spec_helper'

describe Location, type: :model do
  fixtures :users, :clients, :locations, :points_entry_types, :roles

  describe "Name" do
    it "is required" do
      location = Location.new
      location.valid?
      expect(location.errors[:name].size).to eq(1)
    end

    it "must be unique" do
      first = locations :day_shelter
      second = Location.new do |location|
        location.name = first.name
      end

      second.valid?
      expect(second.errors[:name].size).to eq(1)
    end
  end

  describe "default location for user" do
    let(:staff) { users :staff }
    let(:new_staff) { users :new_staff }

    context "with no locations" do
      it "should be nothing" do
        Location.destroy_all
        loc = Location.default_location_for new_staff
        expect(loc).to be_nil
      end
    end

    context "with two locations and no points entries for the user" do
      it "should be the first location" do
        preferred = Location.order(:created_at).first
        result    = Location.default_location_for new_staff

        expect(result).to eq(preferred)
      end
    end

    context "with multiple locations and a points entry for the user" do
      it "should be the location for the points entry" do
        expected = staff.points_entries.last.location
        result = Location.default_location_for new_staff
        expect(result).to eq(expected)
      end
    end
  end
end
