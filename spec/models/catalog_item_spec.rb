require 'spec_helper'

describe CatalogItem, type: :model do

  before(:all) do
    @user = create(:user)
  end

  context "the name" do
    it "must be present" do
      item = CatalogItem.new
      item.valid?
      expect(item.errors[:name].size).to eq(1)
    end

    it "must be unique" do
      item = CatalogItem.create do |i|
        i.name     = "General"
        i.cost     = 1000
        i.added_by = @user
      end

      dupe = CatalogItem.new name: "General"
      dupe.valid?
      expect(dupe.errors[:name].size).to eq(1)
    end
  end

  context "the cost" do
    it "must be present" do
      item = CatalogItem.new
      item.valid?
      expect(item.errors[:cost].size).to eq(2)
    end

    it "must be an integer" do
      item = CatalogItem.new cost: 5.5
      item.valid?
      expect(item.errors[:cost].size).to eq(1)
    end
  end

  it "is created by a User" do
    user = User.create do |u|
      u.login                 = "admin"
      u.password              = "waffle"
      u.password_confirmation = "waffle"
    end

    item = CatalogItem.create do |i|
      i.name     = "General"
      i.cost     = 1000
      i.added_by = @user
    end

    expect(item.added_by).to eq(@user)
  end
end
