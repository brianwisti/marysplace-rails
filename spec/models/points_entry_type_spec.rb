require 'spec_helper'

describe PointsEntryType, type: :model do
  let (:entry_type) { create :points_entry_type }

  it "requires a name" do
    unnamed = PointsEntryType.new do |entry_type|
      entry_type.is_active = true
      entry_type.default_points = 0
    end
    unnamed.valid?
    expect(unnamed.errors[:name].size).to eq(1)
  end

  it "requires a unique name" do
    entry_type = create :points_entry_type
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
      let(:active) { create :points_entry_type, is_active: true }
      let(:inactive) { create :points_entry_type, is_active: false }

      it { is_expected.to include(active) }
      it { is_expected.not_to include(inactive) }
    end
  end

  context "purchase scope" do
    subject { PointsEntryType }
    it { is_expected.to respond_to(:purchase) }

    context "membership" do
      subject { PointsEntryType.purchase }
      let(:purchase) { create :points_entry_type, name: "Purchase" }
      let(:dishes)   { create :points_entry_type, name: "Dishes" }

      it { is_expected.to include(purchase) }
      it { is_expected.not_to include(dishes) }
    end
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
