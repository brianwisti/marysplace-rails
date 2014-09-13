require 'spec_helper'
require 'pp'

describe PointsEntry, type: :model do
  let (:points_entry) { create :points_entry }

  it "should have been added by a User" do
    entry = PointsEntry.create do |entry|
      entry.client            = points_entry.client
      entry.points_entry_type = points_entry.points_entry_type
      entry.points            = points_entry.points
      entry.performed_on      = points_entry.performed_on
    end

    expect(entry.errors[:added_by_id].size).to eq(1)
  end

  it "should have a Location" do
    entry = PointsEntry.create do |entry|
      entry.client            = points_entry.client
      entry.added_by          = points_entry.added_by
      entry.points_entry_type = points_entry.points_entry_type
      entry.points            = points_entry.points
      entry.performed_on      = points_entry.performed_on
    end

    expect(entry.errors[:location_id].size).to eq(1)
  end

  context "points multiple" do
    let(:entry) { create :points_entry }

    context "applied to a new entry" do

      it "requires points_entered" do
        points = 100

        entry.points_entered = nil
        entry.points = points
        entry.valid?

        expect(entry.errors[:points_entered].size).to eq(1)
      end

      it "saves if points_entered is provided" do
        points = 75

        entry.points_entered = points
        entry.points = 0
        entry.save

        expect(entry.points).to eq(points)
      end

      it "allows multiple to be set" do
        points_entered = 50
        multiple = 2
        points = points_entered * multiple

        entry.update_attributes multiple: 2, points_entered: 50
        entry.save

        expect(entry.points).to eq(points)
      end

      it "cannot be applied to negative entered points" do
        entry.update_attributes points: 0, multiple: 2, points_entered: -50
        expect(entry.errors[:multiple].size).to eq(1)
      end

      it "cannot be negative" do
        entry.update_attributes points: 0, multiple: -2, points_entered: 50
        expect(entry.errors[:multiple].size).to eq(1)
      end

    end

    context "updating an existing entry" do
      let(:points)     { 50 }
      let(:multiple)   { 2 }
      let(:new_points) { multiple * points }
      let(:entry)      { create :points_entry, points: points }

      it "can change the multiple" do
        entry.multiple = multiple
        entry.save

        expect(entry.points).to eq(new_points)
      end

      context "Changing points entered" do
        context "with default multiple" do
          before do
            entry.points_entered  = new_points
            entry.save
          end

          it "updates points" do
            expect(entry.points).to eq(new_points)
          end

          it "updates points_entered" do
            expect(entry.points_entered).to eq(new_points)
          end
        end

        context "with non-default multiple" do
          before do
            entry.multiple = multiple
            entry.save
          end

          it "updateds points" do
            expect(entry.points).to eq(new_points)
          end
        end
      end
    end
  end

  context "daily_count" do
    it "starts at zero" do
      expect(PointsEntry.daily_count).to eq(0)
    end

    it "registers new PointsEntry" do
      create :points_entry
      expect(PointsEntry.daily_count).to eq(1)
    end
  end
end
