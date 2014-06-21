require 'spec_helper'

describe Message, type: :model do
  context "content" do
    it "must be present" do
      empty_msg = Message.new
      empty_msg.valid?
      expect(empty_msg.errors[:content].size).to eq(1)
    end
  end
end
