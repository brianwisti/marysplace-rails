require 'spec_helper'

describe Organization do
  let(:first) { Organization.create name: "First", creator_id: 1 }

  context "name" do
    it "must be present" do
      org = Organization.new
      expect(org).to have(1).errors_on(:name)
    end
    
    it "must be unique" do
      org = Organization.new name: first.name
      expect(org).to have(1).errors_on(:name)
    end
  end
end
