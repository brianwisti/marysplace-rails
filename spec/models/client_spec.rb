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

    it "creates a user for login" do
      client.create_login(password: "1234",
                          password_confirmation: "1234")
      expect(client.login).to be_an_instance_of(User)
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

  context "when not shopping" do
    it "knows it's not shopping" do
      expect(client.is_shopping?).to be_falsey
    end

    it "has no cart" do
      expect(client.cart).to be_nil
    end
  end

  context "when shopping" do
    before do
      @cart = StoreCart.start(client, user)
    end

    it "has a cart" do
      expect(client.cart).to eql(@cart)
    end

    it "knows it is shoppings" do
      expect(client.is_shopping?).to be_truthy
    end
  end

  it "can open a Shopping Cart if it has no flags" do
    expect(client.can_shop?).to be_truthy
  end

  describe "Shopping Cart" do
    it "is not allowed if Client has unresolved shop-blocking flags" do
      flag = ClientFlag.create do |f|
        f.created_by = user
        f.client     = client
        f.can_shop   = false
      end
      expect(client.can_shop?).to be_falsey
    end

    it "is not allowed if Client has already shopped this week" do
      StoreCart.start(client, user).finish
      expect(client.can_shop?).to be_falsey
    end

    it "knows if the Client has never shopped" do
      expect(client.has_shopped?).to be_falsey
    end

    it "knows if the Client has shopped" do
      StoreCart.start(client, user).finish
      expect(client.has_shopped?).to be_truthy
    end

    it "remembers the Client's last shopping session" do
      cart = StoreCart.start(client, @user)
      cart.finish
      expect(client.last_shopped_at.to_i).to eql(cart.finished_at.to_i)
    end

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

  describe "collections" do

    context "cannot-shop" do
      it "includes Clients who have unresolved shop-blocking flags" do
        flag = FactoryGirl.create(:bail_flag)
        expect(Client.cannot_shop).to include(flag.client)
      end

      it "includes Clients who have already shopped this week" do
        StoreCart.start(client, user).finish
        expect(Client.cannot_shop).to include(client)
      end

      it "does not include Clients with simple warning Flags" do
        flag = FactoryGirl.create(:client_flag)
        expect(Client.cannot_shop).not_to include(flag.client)
      end

      it "does not include Clients with expired shop-blocking flags" do
        flag = FactoryGirl.create(:bail_flag,
                                  expires_on: 1.day.ago)
        expect(Client.cannot_shop).not_to include(flag.client)
      end

      it "does not include Clients with resolved shop-blocking flags" do
        flag = FactoryGirl.create(:bail_flag,
                                  resolved_on: 1.day.ago)
        expect(Client.cannot_shop).not_to include(flag.client)
      end

      it "does not include Clients with a clean slate" do
        expect(Client.cannot_shop).not_to include(client)
      end
    end
  end

end
