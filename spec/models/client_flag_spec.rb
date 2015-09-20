require 'spec_helper'

describe ClientFlag, type: :model do
  fixtures :client_flags, :clients, :users

  let(:user) { users :admin }
  let(:client) { clients :amy_c }

  describe "active count" do
    it "starts at zero" do
      ClientFlag.destroy_all
      expect(ClientFlag.active_count).to eq(0)
    end

    it "counts unresolved flags" do
      expect(ClientFlag.active_count).to eq(2)
    end
  end
end
