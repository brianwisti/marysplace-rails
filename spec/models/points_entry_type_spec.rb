require 'spec_helper'

describe PointsEntryType, type: :model do
  fixtures :points_entry_types
  let(:entry_type) { points_entry_types :am_dishes }

  it "requires a name" do
    unnamed = PointsEntryType.new do |entry_type|
      entry_type.is_active = true
      entry_type.default_points = 0
    end
    unnamed.valid?
    expect(unnamed.errors[:name].size).to eq(1)
  end

  it "requires a unique name" do
    dupe = PointsEntryType.new do |e|
      e.name = entry_type.name
    end
    dupe.valid?
    expect(dupe.errors[:name].size).to eq(1)
  end

  context "active scope" do
    subject { PointsEntryType }

    it { should respond_to(:active) }

    context "membership" do
      subject { PointsEntryType.active }
      let(:active) { points_entry_types :am_dishes }
      let(:inactive) { points_entry_types :inactive }

      it { should include(active) }
      it { should_not include(inactive) }
    end
  end

  context "quicksearch" do
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
