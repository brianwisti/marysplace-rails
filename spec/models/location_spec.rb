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
    let(:user) { users :staff }

    before do
      @new_user = User.create! do |u|
        u.login = "New Staff"
        u.password = "waffle"
        u.password_confirmation = "waffle"
        u.email = "waffle@example.com"
      end
      @new_user.roles << roles(:staff)
    end

    context "with no locations" do
      it "should be nothing" do
        Location.destroy_all
        loc = Location.default_location_for user
        expect(loc).to be_nil
      end
    end

    context "with one location and no points entries for the user" do
      it "should be the location" do
        loc = locations :day_shelter
        result = Location.default_location_for user
        expect(result).to eq(loc)
      end
    end

    context "with two locations and no points entries for the user" do

      it "should be the first location" do
        preferred = Location.order(:created_at).first
        result    = Location.default_location_for @new_user

        expect(result).to eq(preferred)
      end
    end

    context "with two locations and a points entry for the user" do
      it "should be the location for the points entry" do
        second = locations :overnight

        PointsEntry.create! do |entry|
          entry.client = clients :amy_a
          entry.added_by = @new_user
          entry.location = second
          entry.points_entry_type = points_entry_types :dishes
          entry.points = 50
        end

        result = Location.default_location_for @new_user
        expect(result).to eq(second)
      end
    end
  end
end
