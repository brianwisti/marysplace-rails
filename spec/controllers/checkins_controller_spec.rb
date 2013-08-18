require 'spec_helper'

describe CheckinsController do
  let(:checkin) { create :checkin }
  let(:today) { Date.today }

  describe "Anonymous user" do
    it "cannot access index" do
      get :index
      expect_login response
    end

    it "cannot access show" do
      get :show, id: checkin
      expect_login response
    end

    it "cannot access new" do
      get :new
      expect_login response
    end

    it "cannot access edit" do
      get :edit, id: checkin
      expect_login response
    end

    it "cannot access create" do
      post :create, checkin: attributes_for(:checkin)

      expect_login response
    end

    it "can not create a Checkin" do
      expect {
        post :create, checkin: attributes_for(:checkin)
      }.to change(Checkin, :count).by(0)
    end

    it "cannot access update" do
      put :update, id: checkin, checkin: attributes_for(:checkin)
      expect_login response
    end

    it "cannot access destroy" do
      delete :destroy, id: checkin
      expect_login response
    end

    it "cannot destroy a Checkin" do
      # Specify now or checking will be created in the expect block
      # TODO: Figure out why FactoryGirl does that.
      checkin = create :checkin

      expect {
        delete :destroy, id: checkin
      }.to change(Checkin, :count).by(0)
    end

    it "cannot access today" do
      get :today
      expect_login response
    end

    it "cannot access annual_report" do
      get :annual_report, year: today.year
      expect_login response
    end

    it "cannot access monthly_report" do
      get :monthly_report, year: today.year, month: today.month
      expect_login response
    end

    it "cannot access daily_report" do
      get :daily_report, year: today.year, month: today.month, day: today.day
      expect_login response
    end

    it "cannot access selfcheck" do
      get :selfcheck
      expect_login response
    end

    context "selfcheck" do
      let(:badged_client) { build :client_with_badge }

      it "cannot access selfcheck_post" do
        post :selfcheck_post, login: badged_client.login_code
        expect_login response
      end

      it "cannot create a selfcheck Checkin" do
        expect {
          post :selfcheck_post, login: badged_client.login_code
        }.to change(Checkin, :count).by(0)
      end
    end
  end

  pending "Staff user"
end
