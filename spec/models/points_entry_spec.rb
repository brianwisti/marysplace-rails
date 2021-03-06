require 'spec_helper'
require 'pp'

describe PointsEntry, type: :model do
  fixtures :clients, :locations, :points_entries, :points_entry_types, :users

  let (:points_entry) { points_entries :amy_a_day_shelter_dishes }

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
    let(:entry) { points_entries :amy_a_day_shelter_dishes }

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
      let(:points)     { 25 }
      let(:multiple)   { 2 }
      let(:new_points) { multiple * points }
      let(:entry)      { points_entries :amy_a_day_shelter_dishes }

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
    before { PointsEntry.destroy_all }

    it "starts at zero" do
      PointsEntry.destroy_all
      expect(PointsEntry.daily_count).to eq(0)
    end

    it "registers new PointsEntry" do
      PointsEntry.create do |entry|
        entry.client = clients :amy_a
        entry.added_by = users :staff
        entry.location = locations :overnight
        entry.points_entry_type = points_entry_types :dishes
        entry.points = 25
      end

      expect(PointsEntry.daily_count).to eq(1)
    end
  end

  context "purchases scope" do
    subject { PointsEntry }

    it { is_expected.to respond_to(:purchases) }

    context "membership" do
      subject { PointsEntry.purchases }
      let(:purchase) { points_entries :amy_a_day_shelter_purchase }
      let(:dishes)   { points_entries :amy_a_day_shelter_dishes }

      it { is_expected.to include(purchase) }
      it { is_expected.not_to include(dishes) }
    end
  end
end
