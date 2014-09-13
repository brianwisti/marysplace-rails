require 'spec_helper'

describe Location, type: :model do
  fixtures :clients, :locations, :users, :points_entry_types

  describe "Name" do
    it "is required" do
      location = Location.new
      location.valid?
      expect(location.errors[:name].size).to eq(1)
    end

    it "must be unique" do
      first = locations :prime
      second = Location.new do |location|
        location.name = first.name
      end

      second.valid?
      expect(second.errors[:name].size).to eq(1)
    end
  end

  describe "default location for user" do
    let(:user) { users :staff_user }

    context "with no locations" do
      it "should be nothing" do
        Location.destroy_all
        loc = Location.default_location_for user
        expect(loc).to be_nil
      end
    end

    context "with one location and no points entries for the user" do
      it "should be the location" do
        loc = locations :prime
        result = Location.default_location_for user
        expect(result).to eq(loc)
      end
    end

    context "with two locations and no points entries for the user" do
      it "should be the first location" do
        # Create a new user to minimize noise from other specds
        preferred = Location.order(:id).first
        result    = Location.default_location_for user

        expect(result).to eq(preferred)
      end
    end

    context "with two locations and a points entry for the user" do
      it "should be the location for the points entry" do
        user.points_entries.destroy_all
        second = locations :second

        entry = PointsEntry.create! do |entry|
          entry.client            = clients :normal_client
          entry.added_by          = user
          entry.location          = second
          entry.points_entry_type = points_entry_types :am_dishes
        end
        user.reload

        result = Location.default_location_for user
        expect(result).to eq(second)
      end
    end
  end
end
