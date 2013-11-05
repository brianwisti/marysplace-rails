require 'spec_helper'

describe ClientsController do
  setup :activate_authlogic
  let(:client) { create :client }

  describe "Anonymous user" do
    it "cannot access all" do
      get :all
      expect_login response
    end

    it "cannot access index" do
      get :index
      expect_login response
    end

    it "cannot access search" do
      get :search
      expect_login response
    end

    it "cannot access show" do
      get :show, id: client
      expect_login response
    end

    it "cannot access new" do
      get :new
      expect_login response
    end

    it "cannot access entry" do
      get :entry, id: client
      expect_login response
    end

    it "cannot access create" do
      post :create, client: attributes_for(:client)
      expect_login response
    end

    it "cannot create a Client" do
      expect {
        post :create, client: attributes_for(:client)
      }.to change(Client, :count).by(0)
    end

    it "cannot access update" do
      put :update, id: client, client: attributes_for(:client)
      expect_forbidden response
    end

    it "cannot access edit" do
      get :edit, id: client
      expect_forbidden response
    end

    it "cannot access destroy" do
      delete :destroy, id: client
      expect_forbidden response
    end

    it "cannot access entries" do
      client = create :client

      expect {
        delete :destroy, id: client
      }.to change(Client, :count).by(0)
    end

    it "cannot access checkins" do
      get :checkins, id: client
      expect_forbidden response
    end

    it "cannot access flags" do
      get :flags, id: client
      expect_forbidden response
    end

    it "cannot access new_login" do
      get :new_login, id: client
      expect_forbidden response
    end

    it "cannot access create_login" do
      post :create_login, id: client,
        password: "foo", password_confirmation: "foo"
      expect_forbidden response
    end

    it "cannot create a login" do
      client = create :client
      expect {
        post :create_login, id: client,
          password: "foo", password_confirmation: "foo"
      }.to change(User, :count).by(0)
    end

    it "cannot access card" do
      get :card, id: client
      expect_forbidden response
    end

    it "cannot access purchases" do
      get :purchases, id: client
      expect_forbidden response
    end
  end
end
