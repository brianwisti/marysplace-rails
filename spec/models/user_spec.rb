require 'spec_helper'

describe User, type: :model do
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

    it { should respond_to(:establish_roles) }

    context "Establishing multiple roles" do
      let(:user) { create :user }
      let(:admin_role) { create :admin_role }
      let(:staff_role) { create :staff_role }
      let(:front_desk_role) { create :front_desk_role }
      let(:is_admin) { user.role? :admin }
      let(:is_staff) { user.role? :staff }
      let(:is_front_desk) { user.role? :front_desk }
      let(:specified_roles) { [ admin_role, staff_role, front_desk_role ]}

      context "when user has no roles" do
        before { user.roles.delete_all }

        it "accepts the roles" do
          user.establish_roles specified_roles
          expect(is_admin).to be(true)
          expect(is_staff).to be(true)
          expect(is_front_desk).to be(true)
        end
      end

      context "when user has roles not specified" do
        before do
          user.accept_role admin_role
        end

        let(:non_admin_roles) { specified_roles - [ admin_role ] }

        it "removes the unspecified roles" do
          user.establish_roles non_admin_roles
          expect(is_admin).to be(false)
          expect(is_staff).to be(true)
          expect(is_front_desk).to be(true)
        end
      end

    end
  end
end
