require 'spec_helper'

describe Message do
  subject(:message) { create :message }

  context "content" do
    it { should respond_to(:content) }

    context "presence" do
      before { message.content = nil }
      subject(:no_content) { Message.new }

      it { should have(1).errors_on(:content) }
    end
  end

  context "title" do
  end

end
