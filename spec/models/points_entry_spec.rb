require 'spec_helper'
require 'pp'

describe PointsEntry do
  let (:points_entry) { create :points_entry }

  it "should have been added by a User" do
    entry = PointsEntry.create do |entry|
      entry.client            = points_entry.client
      entry.points_entry_type = points_entry.points_entry_type
      entry.points            = points_entry.points
      entry.performed_on      = points_entry.performed_on
    end

    expect(entry).to have(1).errors_on(:added_by_id)
  end

  it "should have a Location" do
    entry = PointsEntry.create do |entry|
      entry.client            = points_entry.client
      entry.added_by          = points_entry.added_by
      entry.points_entry_type = points_entry.points_entry_type
      entry.points            = points_entry.points
      entry.performed_on      = points_entry.performed_on
    end

    expect(entry).to have(1).errors_on(:location_id)
  end
end
