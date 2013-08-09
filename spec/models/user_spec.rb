require 'spec_helper'

describe User do

  context "validation" do
    it "does not allow an empty login" do
      u = User.new
      expect(u.errors[:login]).not_to be(:empty?)
    end

    it "requires a unique login" do
      user = FactoryGirl.create(:user)
      dupe = FactoryGirl.build(:user, login: user.login)
      expect(dupe.errors[:login]).not_to be(:empty?)
    end
  end
end
