require 'rails_helper'

describe User, type: :model do
  fixtures :roles, :users

  context "login" do
    let(:user) { User.new }
    subject { user.errors[:login] }

    context "cannot be empty" do
      it { is_expected.not_to be(:empty?) }
    end

    context "must be unique" do
      let(:first) { users :simple }
      let(:dupe) { build :user, login: user.login }
      subject { first.errors[:login] }
      it { is_expected.not_to be(:empty?) }
    end
  end

  context "Role" do
    before do
      @role = roles :volunteer
      @user = users :simple
    end

    subject { @user }

    it { is_expected.to respond_to(:roles) }
    it { is_expected.to respond_to(:role?) }

    context "Checking" do
      subject { @user.role? @role.name }

      context "when user does not have a role" do
        it { is_expected.to be(false) }
      end

      context "when user has a role" do
        before { @user.roles.push @role }
        it { is_expected.to be(true) }
      end
    end

    it { is_expected.to respond_to(:accept_role) }

    context "Accepting" do
      before { @user.accept_role @role }

      subject { @user.role? @role.name }
      it { is_expected.to be(true) }
    end

    it { is_expected.to respond_to(:withdraw_role) }

    context "Withdrawing" do
      before { @user.accept_role @role }

      it "removes the role" do
        @user.withdraw_role @role
        has_role = @user.role? @role.name
        expect(has_role).to be(false)
      end
    end

    it { is_expected.to respond_to(:establish_roles) }

    context "Establishing multiple roles" do
      before do
        @admin_role = roles :admin
        @staff_role = roles :staff
        @front_desk_role = roles :front_desk
      end

      let(:is_admin) { @user.role? :admin }
      let(:is_staff) { @user.role? :staff }
      let(:is_front_desk) { @user.role? :front_desk }
      let(:specified_roles) { [ @admin_role, @staff_role, @front_desk_role ]}

      context "when user has no roles" do
        before { @user.roles.delete_all }

        it "accepts the roles" do
          @user.establish_roles specified_roles
          expect(is_admin).to be(true)
          expect(is_staff).to be(true)
          expect(is_front_desk).to be(true)
        end
      end

      context "when user has roles not specified" do
        before do
          @user.accept_role @admin_role
        end

        let(:non_admin_roles) { specified_roles - [ @admin_role ] }

        it "removes the unspecified roles" do
          @user.establish_roles non_admin_roles
          expect(is_admin).to be(false)
          expect(is_staff).to be(true)
          expect(is_front_desk).to be(true)
        end
      end
    end
  end

  context "preference" do
    let(:user) { User.new }

    it "is accessed via preference_for" do
      expect(user).to respond_to(:preference_for)
    end

    it "uses defaults if not set" do
      setting = :client_fields
      prefs = user.preference_for setting
      defaults = Preference.default_for setting
      expect(defaults).to eql(prefs)
    end

    it "remembers preferences with remember_preference" do
      expect(user).to respond_to(:remember_preference)
    end

    it "uses saved values if set" do
      user = users :simple
      user.remember_preference client_fields: %w{ point_balance }
      prefs = user.preference_for :client_fields
      expect(prefs).to include('point_balance')
      expect(prefs).to_not include('created_at')
    end
  end
end
