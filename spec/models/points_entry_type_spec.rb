require 'spec_helper'

describe PointsEntryType, type: :model do
  fixtures :points_entry_types

  let (:entry_type) { points_entry_types :boil_eggs }

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

    it { is_expected.to respond_to(:active) }

    context "membership" do
      subject { PointsEntryType.active }
      let(:active) { points_entry_types :boil_eggs }
      let(:inactive) { points_entry_types :inactive_chore }

      it { is_expected.to include(active) }
      it { is_expected.not_to include(inactive) }
    end
  end

  context "purchase scope" do
    subject { PointsEntryType }
    it { is_expected.to respond_to(:purchase) }

    context "membership" do
      subject { PointsEntryType.purchase }
      let(:purchase) { points_entry_types :purchase }
      let(:dishes)   { points_entry_types :dishes }

      it { is_expected.to include(purchase) }
      it { is_expected.not_to include(dishes) }
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
