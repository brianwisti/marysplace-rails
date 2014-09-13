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

    it "cannot access edit" do
      get :edit, id: message
      expect_login response
    end

    it "cannot access create" do
      post :create, message: build_attributes(:message)
      expect_login response
    end
  end

  describe "Staff user" do
    let(:staff_user) { create :staff_user }

    before do
      login staff_user
    end

    it "can access index" do
      get :index
      expect(response).to be_success
    end

    it "can access show" do
      get :show, id: message
      expect(response).to be_success
    end

    it "cannot access edit" do
      get :edit, id: message
      expect_forbidden response
    end
  end
end
