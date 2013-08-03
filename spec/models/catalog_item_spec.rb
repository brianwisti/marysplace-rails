require 'spec_helper'

describe CatalogItem do

  before(:all) do
    @user = User.create do |u|
      u.login                 = "admin"
      u.password              = "waffle"
      u.password_confirmation = "waffle"
    end
  end

  context "the name" do
    it "must be present" do
      expect(CatalogItem.new).to have(1).errors_on(:name)
    end

    it "must be unique" do
      item = CatalogItem.create do |i|
        i.name     = "General"
        i.cost     = 1000
        i.added_by = @user
      end

      expect(CatalogItem.new(name: "General")).to have(1).errors_on(:name)
    end
  end

  context "the cost" do
    it "must be present" do
      expect(CatalogItem.new).to have(2).errors_on(:cost)
    end

    it "must be an integer" do
      expect(CatalogItem.new(cost: 5.5)).to have(1).errors_on(:cost)
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