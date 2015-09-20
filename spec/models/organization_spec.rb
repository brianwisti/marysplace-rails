require 'spec_helper'

describe Organization, type: :model do
  fixtures :users

  let(:site_admin) { users :site_admin }
  let(:first) { Organization.create! name: "First", creator: site_admin }

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
