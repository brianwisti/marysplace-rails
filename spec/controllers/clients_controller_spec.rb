require 'spec_helper'

describe ClientsController do
  setup :activate_authlogic
  let(:client) { create :client }

  describe "anonymous user" do
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

    it "cannot create a client" do
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

  describe "staff user" do
    let(:staff_user) { create :staff_user }

    before do
      login staff_user
    end

    it "can access all" do
      get :all
      expect(response).to render_template(:all)
    end

    it "can access index" do
      get :index
      expect(response).to render_template(:index)
    end

    it "can access search" do
      get :search
      expect(response).to render_template(:search)
    end

    it "can access show" do
      get :show, id: client
      expect(response).to render_template(:show)
    end

    it "can access new" do
      get :new
      expect(response).to render_template(:new)
    end

    it "can access entry" do
      get :entry, id:client
      expect(response).to render_template(:entry)
    end

    it "can access create" do
      post :create, client: attributes_for(:client)
      expect(response).to redirect_to(client_url(assigns(:client)))
    end

    it "can create a client" do
      expect {
        post :create, client: attributes_for(:client)
      }.to change(Client, :count).by(1)
    end

    it "can access update" do
      client = create :client
      post :update, id: client, client: attributes_for(:client)
    end

    it "can access edit" do
      get :edit, id: client
      expect(response).to render_template(:edit)
    end

    it "can access destroy" do
      client = create :client
      delete :destroy, id: client
      expect(response).to redirect_to(clients_url)
    end

    it "can access entries" do
      get :entries, id: client
      expect(response).to render_template(:entries)
    end

    it "can access checkins" do
      get :checkins, id: client
      expect(response).to render_template(:checkins)
    end

    it "can access flags" do
      get :flags, id: client
      expect(response).to render_template(:flags)
    end

    it "can access new_login" do
      get :new_login, id: client
    end

    it "can access create_login" do
      password = "waffle"
      post :create_login, id: client,
        password: password,
        password_confirmation: password
      expect(response).to redirect_to(client_url(assigns(:client)))
    end

    it "can create a login" do
      client = create :client
      password = "waffle"
      expect {
        post :create_login, id: client,
          password: password,
          password_confirmation: password
      }.to change(User, :count).by(1)
    end

    it "can access card" do
      get :card, id: client
      expect(response).to render_template(layout: :card)
    end

    it "can access purchases" do
      get :purchases, id: client
      expect(response).to render_template(:purchases)
    end
  end
end
