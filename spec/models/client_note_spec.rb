require 'spec_helper'

describe ClientNote do
  let(:user) { create :user }
  let(:client) { create :client }

  describe "fields" do
    subject(:note) { ClientNote.new }
    before { note.save }

    describe "content" do
      context "empty" do
        it { should have(1).errors_on(:content) }
      end

      context "with content" do
        before { note.content = "Stuff and things" }
        it { should have(0).errors_on(:content) }
      end
    end

    describe "user" do
      context "empty" do
        it { should have(1).errors_on(:user) }
      end

      context "with user" do
        before { note.user = user }
        it { should have(0).errors_on(:user) }
      end
    end

    describe "client" do
      context "empty" do
        it { should have(1).errors_on(:client) }
      end

      context "with client" do
        before { note.client = client }
        it { should have(0).errors_on(:client) }
      end
    end
  end
end
