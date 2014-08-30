require 'spec_helper'

describe Organization, type: :model do
  let(:site_admin) { create :user }
  let(:first) { Organization.create name: "First", creator_id: 1 }

  context "name" do
    it "must be present" do
      org = Organization.new
      org.valid?
      expect(org.errors[:name].size).to eq(1)
    end

    it "must be unique" do
      org = Organization.new name: first.name
      org.valid?
      expect(org.errors[:name].size).to eq(1)
    end
  end

  context "creator" do
    it "must be present" do
      org = Organization.new
      org.valid?
      expect(org.errors[:creator_id].size).to eq(1)
    end
  end
end
