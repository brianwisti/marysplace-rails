require 'spec_helper'

describe User do
  context "login" do
    let(:user) { User.new }
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

  context "Role" do
    let(:role) { create :role }
    let(:user) { create :user }
    subject { user }

    it { should respond_to(:roles) }
    it { should respond_to(:role?) }

    context "Checking" do
      subject { user.role? role.name }

      context "when user does not have a role" do
        it { should be(false) }
      end

      context "when user has a role" do
        before { user.roles.push role }
        it { should be(true) }
      end
    end

    it { should respond_to(:accept_role) }

    context "Accepting" do
      let(:user) { create :user }
      before { user.accept_role role }

      subject { user.role? role.name }
      it { should be(true) }
    end

    it { should respond_to(:withdraw_role) }

    context "Withdrawing" do
      let(:user) { create :user }
      before { user.accept_role role }

      it "removes the role" do
        user.withdraw_role role
        has_role = user.role? role.name
        expect(has_role).to be(false)
      end
    end

    pending "Establishing all roles" do
    end
  end
end
