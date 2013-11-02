require 'spec_helper'

describe PointsEntriesController do
  setup :activate_authlogic

  let(:entry) { create :points_entry }

  describe "Anonymous user" do
    it "cannot access index" do
      get :index
      expect_login response
    end

    it "cannot acess show" do
      get :show, id: entry
      expect_forbidden response
    end
  end
end
