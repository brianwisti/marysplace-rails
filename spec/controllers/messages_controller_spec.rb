require 'spec_helper'

describe MessagesController do
  setup :activate_authlogic
  let(:message) { create :message }

  describe "Anonymous user" do
    it "cannot access index" do
      get :index
      expect_login response
    end

    it "cannot access show" do
      get :show, id: message
      expect_login response
    end

    it "cannot access new" do
      get :new
      expect_login response
    end
  end
end
