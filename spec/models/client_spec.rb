require 'spec_helper'

describe Client do
  before(:all) do
    @user = User.create! do |u|
      u.login                 = "super"
      u.password              = "waffle"
      u.password_confirmation = "waffle"
    end

    @client = Client.create! do |c|
      c.current_alias = "Client C."
      c.added_by      = @user
    end
  end

  describe "validation" do
    context "the current alias" do
      it "must be present" do
        client = Client.new
        expect(client).to have(1).errors_on(:current_alias)
      end

      it "must be unique" do
        client = Client.new(current_alias: @client.current_alias)
        expect(client).to have(1).errors_on(:current_alias)
      end
    end

    context "the user adding the client" do
      it "must be specified" do
        client = Client.new
        expect(client).to have(1).errors_on(:added_by_id)
      end
    end
  end

  context "automated checkin system" do
    it "creates a user for login" do
      @client.create_login(password: "1234",
                           password_confirmation: "1234")
      expect(@client.login).to be_an_instance_of(User)
    end
  end

  describe "Flag tracking" do
    it "knows when it has unresolved flags" do
      flag = ClientFlag.create do |f|
        f.created_by = @user
        f.client     = @client
        f.can_shop   = false
      end
      expect(@client.is_flagged?).to be_true
    end

    it "knows when it has no unresolved flags" do
      expect(@client.is_flagged?).to be_false
    end
  end

  describe "shopping" do
    it "is allowed if Client has no flags" do
      expect(@client.can_shop?).to be_true
    end

    it "is not allowed if Client has unresolved shop-blocking flags" do
      flag = ClientFlag.create do |f|
        f.created_by = @user
        f.client     = @client
        f.can_shop   = false
      end
      expect(@client.can_shop?).to be_false
    end

    it "is not allowed if Client has already shopped this week" do
      StoreCart.start(@client, @user).finish
      expect(@client.can_shop?).to be_false
    end
  end
end
