require 'spec_helper'

describe Client do
  before(:all) do
    @user = User.create do |u|
      u.login                 = "admin"
      u.password              = "waffle"
      u.password_confirmation = "waffle"
    end
  end

  context "the current alias" do
    it "must be present" do
      client = Client.new
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
