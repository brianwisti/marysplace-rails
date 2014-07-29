require 'spec_helper'

describe Preference do
  let(:user) { create :user }

  context "user association" do
    it "is required" do
      pref = Preference.new
      pref.valid?
      expect(pref.errors[:user_id].size).to eq(1)
    end
  end

  context "client_fields" do
    context "default" do
      let(:default) { Preference.default_for :client_fields }

      it "contains current_alias" do
        expect(default).to include('current_alias')
      end

      it "contains point_balance" do
        expect(default).to include('point_balance')
      end

      it "contains created_at" do
        expect(default).to include('created_at')
      end

    end

    skip "setting"
  end
end
