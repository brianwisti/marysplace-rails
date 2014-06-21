require 'spec_helper'

describe ClientFlag, type: :model do
  let(:user) { create :admin_user }
  let(:client) { create :client }

  describe "active count" do
    it "starts at zero" do
      expect(ClientFlag.active_count).to eq(0)
    end

    it "counts unresolved flags" do
      create :client_flag
      expect(ClientFlag.active_count).to eq(1)
    end

    it "doesn't count resolved flags" do
      flag = create :resolved_flag
      expect(ClientFlag.active_count).to eq(0)
    end
  end
end
