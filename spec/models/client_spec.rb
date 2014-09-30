require 'spec_helper'

describe Client, type: :model do
  let(:user)   { create :staff_user }
  let(:client) { create :client, added_by: user }

  describe "validation" do
    context "the current alias" do
      it "must be present" do
        client = Client.new
        client.valid?
        expect(client.errors[:current_alias].size).to eq(1)
      end

      it "must be unique" do
        dupe = Client.new(current_alias: client.current_alias)
        dupe.valid?
        expect(dupe.errors[:current_alias].size).to eq(1)
      end
    end

    context "the user adding the client" do
      it "must be specified" do
        client = Client.new
        client.valid?
        expect(client.errors[:added_by_id].size).to eq(1)
      end
    end

    context "organization" do
      it "matches added_by org if available" do
        client.save!
        client.reload
        expect(client.organization).to eql(user.organization)
      end
    end
  end

  describe "quicksearch" do
    before do
      create :client, current_alias: "Amy A."
      create :client, current_alias: "Amy B."
      create :client, current_alias: "S. Amy", other_aliases: "Deborah"
      create :client, current_alias: "Amy C.", is_active: false
    end

    it "returns a case-insensitive substring match of active Clients" do
      results = Client.quicksearch "Amy"
      expect(results.length).to eql(3)
    end

    it "finds exact matches against current_alias" do
      results = Client.quicksearch "Amy A."
      expect(results.length).to eql(1)
    end

    it "matches against other_aliases" do
      results = Client.quicksearch "Deborah"
      expect(results.length).to eql(1)
    end

  end

  context "automated checkin system" do
    it "starts uninitialized for each client" do
      expect(client.checkin_code).to be_nil
    end

    it "is automatically set on request" do
      client.update_checkin_code!
      expect(client.checkin_code).to_not be_nil
    end
  end

  describe "Flag tracking" do

    it "knows when it has unresolved flags" do
      flag = ClientFlag.create do |f|
        f.created_by = user
        f.client     = client
        f.can_shop   = false
      end
      expect(client.is_flagged?).to be_truthy
    end

    it "knows when it has no unresolved flags" do
      expect(client.is_flagged?).to be_falsey
    end
  end

  it "can open a Shopping Cart if it has no flags" do
    expect(client.can_shop?).to be_truthy
  end

  describe "Shopping Cart" do

    context "Purchase PointsEntries" do
      let(:purchase_type) { create :points_entry_type, name: "Purchase" }
      let(:location) { create :location }

      it "count as shopping visits" do
       FactoryGirl.create :points_entry,
         client: client,
         points_entry_type: purchase_type,
         location: location
        client.reload

        expect(client.has_shopped?).to be_truthy
      end

      it "is tracked for last shopping visit" do
        entry_type = PointsEntryType.create(name: 'Purchase')
        entry = client.points_entries.create! do |entry|
          entry.points_entry_type = entry_type
          entry.added_by          = user
          entry.points            = -100
          entry.performed_on      = Date.today
          entry.location          = create(:location)
        end
        client.reload
        expect(client.last_shopped_at.to_i).to eql(entry.performed_on.to_time.to_i)
      end
    end

  end
end
