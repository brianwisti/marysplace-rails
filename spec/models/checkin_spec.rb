require 'spec_helper'

describe Checkin do
  it "should be unique per client per day" do

    user = User.create do |u|
      u.login                 = "admin"
      u.password              = "waffle"
      u.password_confirmation = "waffle"
    end

    client = Client.create do |c|
      c.current_alias = "Amy A."
      c.added_by      = user
    end

    at = DateTime.now

    checkin = Checkin.create do |ch|
      ch.user = user
      ch.client = client
      ch.checkin_at = at
    end

    dupe = Checkin.new do |ch|
      ch.user = user
      ch.client = client
      ch.checkin_at = at
    end

    expect(dupe).to have(1).errors_on(:client_id)
  end
end
