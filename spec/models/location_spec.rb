require 'spec_helper'

describe Location do
  describe "Name" do
    it "is required" do
      location = Location.new
      expect(location).to have(1).errors_on(:name)
    end

    it "must be unique" do
      first = FactoryGirl.create(:location)
      second = Location.new do |location|
        location.name = first.name
      end

      expect(second).to have(1).errors_on(:name)
    end
  end
end
