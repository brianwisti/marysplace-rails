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

    context "setting" do
      let(:pref) { Preference.new(user: user) }

      it "accepts an array" do
        pref.client_fields = [ 'current_alias', 'point_balance' ]
        pref.valid?
        expect(pref.errors[:client_fields].size).to eq(0)
      end

      it "requires valid client attributes" do
        pref.client_fields = %w{ waffle_house }
        pref.valid?
        expect(pref.errors[:client_fields].size).to eq(1)
      end
    end
  end
end
