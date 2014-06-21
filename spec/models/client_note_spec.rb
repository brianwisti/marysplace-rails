require 'spec_helper'

describe ClientNote, type: :model do
  let(:user) { create :user }
  let(:client) { create :client }

  describe "fields" do
    let(:note) { ClientNote.new }

    describe "content" do
      it "must be present" do
        note = ClientNote.new
        note.valid?
        expect(note.errors[:content].size).to eq(1)
        note.content = "Stuff and things"
        note.valid?
        expect(note.errors[:content].size).to eq(0)
      end
    end

    describe "user" do
      it "must be present" do
        note.valid?
        expect(note.errors[:user].size).to eq(1)

        note.user = user
        note.valid?
        expect(note.errors[:user].size).to eq(0)
      end
    end

    describe "client" do
      it "must be present" do
        note.valid?
        expect(note.errors[:client].size).to eq(1)

        note.client = client
        note.valid?
        expect(note.errors[:client].size).to eq(0)
      end
    end
  end
end
