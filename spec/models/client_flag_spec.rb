require 'spec_helper'

describe ClientFlag, type: :model do
  fixtures :client_flags, :clients, :users
  let(:user) { users :admin_user }
  let(:client) { clients :normal_client }

  describe "active count" do
    it "starts at zero" do
      ClientFlag.destroy_all
      expect(ClientFlag.active_count).to eq(0)
    end

    it "counts unresolved flags" do
      expect(ClientFlag.active_count).to eq(3)
    end

    it "doesn't count resolved flags" do
      client_flags(:bail_flag).update_attributes resolved_on: Date.today, resolved_by_id: user.id
      expect(ClientFlag.active_count).to eq(2)
    end
  end
end
