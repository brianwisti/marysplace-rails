require 'spec_helper'

describe Client, type: :model do
  fixtures :users, :clients, :locations, :points_entry_types

  let(:user)   { users :staff }
  let(:client) { clients :anna_a }

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
      let(:purchase_type) { points_entry_types :purchase }
      let(:day_shelter) { locations :day_shelter }

      it "count as shopping visits" do
        PointsEntry.create do |entry|
          entry.client = client
          entry.added_by = user
          entry.points_entry_type = purchase_type
          entry.location = day_shelter
        end
        client.reload

        expect(client.has_shopped?).to be_truthy
      end

      it "is tracked for last shopping visit" do
        entry = client.points_entries.create! do |entry|
          entry.points_entry_type = purchase_type
          entry.added_by          = user
          entry.points            = -100
          entry.performed_on      = Date.today
          entry.location          = day_shelter
        end
        client.reload
        expect(client.last_shopped_at.to_i).to eql(entry.performed_on.to_time.to_i)
      end
    end

  end

  describe "Last Activity" do
    let(:idra) { clients(:idle_idra) }
    let(:dishes) { points_entry_types :dishes }
    let(:day_shelter) { locations :day_shelter }

    it "defaults to a Client's creation date for new clients" do
      client = Client.create do |c|
        c.current_alias = "new client"
        c.added_by      = user
      end
      expect(client.last_activity_on).to eql(client.created_at.to_date)
    end

    it "is the client creation date while they have no points entries" do
      idra.update_last_activity!
      idra.reload
      expect(idra.last_activity_on).to eql(idra.created_at.to_date)
    end

    it "is updated when the client gets a new points entry" do
      entry = PointsEntry.create do |entry|
        entry.client = idra
        entry.added_by = user
        entry.points_entry_type = dishes
        entry.location = day_shelter
      end

      expect(idra.last_activity_on).to eql(entry.performed_on)
    end
  end
end
