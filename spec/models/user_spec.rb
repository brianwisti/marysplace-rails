require 'spec_helper'

describe User do

  context "validation" do
    let(:user) { User.new }

    context "login" do
      subject { user.errors[:login] }

      context "cannot be empty" do
        it { should_not be(:empty?) }
      end

      context "must be unique" do
        let(:first) { create :user }
        let(:dupe) { build :user, login: user.login }
        subject { first.errors[:login] }
        it { should_not be(:empty?) }
      end
    end
  end
end
