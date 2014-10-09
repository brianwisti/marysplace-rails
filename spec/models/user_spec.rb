require 'spec_helper'

describe User, type: :model do
  context "login" do
    let(:user) { User.new }
    subject { user.errors[:login] }

    context "cannot be empty" do
      it { is_expected.not_to be(:empty?) }
    end

    context "must be unique" do
      let(:first) { create :user }
      let(:dupe) { build :user, login: user.login }
      subject { first.errors[:login] }
      it { is_expected.not_to be(:empty?) }
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
      user = create :user
      user.remember_preference client_fields: %w{ point_balance }
      prefs = user.preference_for :client_fields
      expect(prefs).to include('point_balance')
      expect(prefs).to_not include('created_at')
    end
  end
end
