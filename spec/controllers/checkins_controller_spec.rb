require 'spec_helper'

describe CheckinsController do
  setup :activate_authlogic

  let(:checkin) { create :checkin }
  let(:today) { Date.today }

  describe "Anonymous user" do
    it "cannot access index" do
      get :index
      expect_login response
    end

    it "cannot access show" do
      get :show, id: checkin
      expect_forbidden response
    end

    it "cannot access new" do
      get :new
      expect_login response
    end

    it "cannot access edit" do
      get :edit, id: checkin
      expect_forbidden response
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
      expect_forbidden response
    end

    it "cannot access destroy" do
      delete :destroy, id: checkin
      expect_forbidden response
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
        expect_forbidden response
      end

      it "cannot create a selfcheck Checkin" do
        expect {
          post :selfcheck_post, login: badged_client.login_code
        }.to change(Checkin, :count).by(0)
      end
    end
  end

  describe "Staff user" do
    let(:staff_user) { create :staff_user }

    before do
      login staff_user
    end

    it "can access index" do
      get :index
      expect(response).to render_template(:index)
    end

    it "sees some checkins on index" do
      get :index
      expect(assigns(:checkins)).to_not be_nil
    end

    it "can access show" do
      get :show, id: checkin
      expect(response).to render_template(:show)
    end

    it "sees a checkin on show" do
      get :show, id: checkin
      expect(assigns(:checkin)).to eql(checkin)
    end

    it "can access new" do
      get :new
      expect(response).to render_template(:new)
    end

    it "can access edit" do
      get :edit, id: checkin
      expect(response).to render_template(:edit)
    end

    it "sees a checkin to edit" do
      get :edit, id: checkin
      expect(assigns(:checkin)).to eql(checkin)
    end

    it "can access create" do
      post :create, checkin: build_attributes(:checkin)
      expect(response).to redirect_to(new_checkin_url)
    end

    it "can create a Checkin" do
      expect {
        post :create, checkin: build_attributes(:checkin)
      }.to change(Checkin, :count).by(1)
    end

    it "can access update" do
      put :update, id: checkin, checkin: attributes_for(:checkin, notes: "Notes here")
      expect(response).to redirect_to(checkin)
    end

    it "can update a Checkin" do
      put :update, id: checkin, checkin: attributes_for(:checkin, notes: "Notes here")
      expect(checkin.reload.notes).to eq("Notes here")
    end

    it "can access destroy" do
      delete :destroy, id: checkin
      expect(response).to redirect_to(checkins_url)
    end

    it "can destroy a Checkin" do
      # Specify now or checking will be created in the expect block
      # TODO: Figure out why FactoryGirl does that.
      checkin = create :checkin

      expect {
        delete :destroy, id: checkin
      }.to change(Checkin, :count).by(-1)
    end

    it "can access today" do
      get :today
      expect(response).to render_template(:daily_report)
    end

    it "can access annual_report" do
      get :annual_report, year: today.year
      expect(response).to render_template(:annual_report)
    end

    it "can access monthly_report" do
      get :monthly_report, year: today.year, month: today.month
      expect(response).to render_template(:monthly_report)
    end

    it "can access daily_report" do
      get :daily_report, year: today.year, month: today.month, day: today.month
      expect(response).to render_template(:daily_report)
    end

    it "can access selfcheck" do
      get :selfcheck
      expect(response).to render_template(:selfcheck)
    end

    context "selfcheck" do
      let(:badged_client) { create :client_with_badge }
      let(:location) { create :location }

      it "can access selfcheck_post" do
        post :selfcheck_post, login: badged_client.login_code, location_id: location.id
        expect(response).to redirect_to(selfcheck_checkins_url)
      end

      it "can create a selfcheck Checkin" do
        expect {
          post :selfcheck_post, login: badged_client.login_code, location_id: location.id
        }.to change(Checkin, :count).by(1)
      end

      it "sees a notice after creating a selfcheck Checkin" do
        post :selfcheck_post, login: badged_client.login_code, location_id: location.id
        expect(flash[:notice]).to_not be_nil
      end

      it "gets an error when creating an invalid selfcheck Checkin" do
        post :selfcheck_post, login: "12345678", location_id: location.id
        expect(flash[:alert]).to_not be_nil
      end
    end
  end
end
