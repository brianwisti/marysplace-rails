require 'spec_helper'

describe PointsEntryType do
  let (:entry_type) { create :points_entry_type }

  it "requires a name" do
    unnamed = PointsEntryType.new do |entry_type|
      entry_type.is_active = true
      entry_type.default_points = 0
    end
    expect(unnamed).to have(1).errors_on(:name)
  end

  it "requires a unique name" do
    dupe = PointsEntryType.new do |e|
      e.name = entry_type.name
    end
    expect(dupe).to have(1).errors_on(:name)
  end

  context "quicksearch" do
    before do
      create :points_entry_type, name: "AM Bathroom"
      create :points_entry_type, name: "PM Bathroom"
    end

    it "can return an exact match" do
      results = PointsEntryType.quicksearch "AM Bathroom"
      expect(results.length).to eql(1)
    end

    it "can return a case-insensitive substring match" do
      results = PointsEntryType.quicksearch "bathroom"
      expect(results.length).to eql(2)
    end
  end
end
