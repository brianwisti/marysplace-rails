require 'spec_helper'

describe Checkin do
  before(:all) do
    @user = User.create do |u|
      u.login                 = "admin"
      u.password              = "waffle"
      u.password_confirmation = "waffle"
    end

    @client = Client.create do |c|
      c.current_alias = "Amy A."
      c.added_by      = @user
    end

    @at = DateTime.now

    @location = FactoryGirl.create(:location)

    @checkin = Checkin.create do |c|
      c.user       = @user
      c.client     = @client
      c.checkin_at = @at
      c.location   = @location
    end
  end

  it "should be unique per client per day" do
    dupe = Checkin.new do |ch|
      ch.user       = @user
      ch.client     = @client
      ch.checkin_at = @at
    end

    expect(dupe).to have(1).errors_on(:client_id)
  end

  it "should have a Location" do
    checkin = Checkin.create do |ch|
      ch.user       = @user
      ch.client     = @client
      ch.checkin_at = @at
    end

    expect(checkin).to have(1).errors_on(:location_id)
  end
end
