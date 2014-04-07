require 'spec_helper'

describe ClientFlag do
  let(:user) { create :admin_user }
  let(:client) { create :client }

  describe "count unresolved flags" do
    subject { ClientFlag }
    it { should respond_to(:active_count) }

    context "with no flags" do
      its(:active_count) { should eq(0) }
    end

    context "with unresolved flags" do
      before { create :client_flag }
      its(:active_count) { should eq(1) }
    end

    context "with resolved flags" do
      before do
        flag = create :resolved_flag
      end

      its(:active_count) { should eq(0) }
    end
  end
end
