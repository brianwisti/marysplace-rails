require 'rails_helper'

describe CheckinsController, :type => :controller do
  setup :activate_authlogic
  fixtures :checkins, :clients, :locations, :users

  let(:checkin) { checkins :amy_a_overnight }
  let(:today)   { Date.today }

  before do
    @attributes = {
      client_id: clients(:amy_b),
      location_id: locations(:overnight),
      checkin_at: DateTime.now
    }
  end

  describe "Staff user" do

    before do
      login users :staff
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
      post :create, checkin: @attributes
      expect(response).to redirect_to(new_checkin_url)
    end

    it "can create a Checkin" do
      expect {
        post :create, checkin: @attributes
      }.to change(Checkin, :count).by(1)
    end

    it "can access update" do
      put :update, id: checkin, checkin: @attributes
      expect(response).to redirect_to(checkin)
    end

    it "can update a Checkin" do
      @attributes[:notes] = "Notes here"
      put :update, id: checkin, checkin: @attributes
      expect(checkin.reload.notes).to eq("Notes here")
    end

    it "can access destroy" do
      delete :destroy, id: checkin
      expect(response).to redirect_to(checkins_url)
    end

    it "can destroy a Checkin" do
      # Specify now or checking will be created in the expect block
      # TODO: Figure out why FactoryGirl does that.
      expect {
        delete :destroy, id: checkin
      }.to change(Checkin, :count).by(-1)
    end

    context ":today" do
      it "is accessible" do
        get :today
        expect(response).to render_template(:daily_report)
      end

      skip "shows today's checkins" do
        post :create, checkin: @attributes
        get :today
        expect(assigns(:checkins)).to include(checkin)
      end
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
      let(:badged_client) { clients :badged_brenda }
      let(:location) { locations :overnight }

      it "can access selfcheck_post" do
        post :selfcheck_post, login: badged_client.checkin_code, location_id: location.id
        expect(response).to redirect_to(selfcheck_checkins_url)
      end

      it "can create a selfcheck Checkin" do
        expect {
          post :selfcheck_post, login: badged_client.checkin_code, location_id: location.id
        }.to change(Checkin, :count).by(1)
      end

      it "sees a notice after creating a selfcheck Checkin" do
        post :selfcheck_post, login: badged_client.checkin_code, location_id: location.id
        expect(flash[:notice]).to_not be_nil
      end

      it "gets an error when creating an invalid selfcheck Checkin" do
        post :selfcheck_post, login: "12345678", location_id: location.id
        expect(flash[:alert]).to_not be_nil
      end

      it "gets an error when duplicating a selfcheck" do
        post :selfcheck_post, login: badged_client.checkin_code, location_id: location.id
        post :selfcheck_post, login: badged_client.checkin_code, location_id: location.id
        expect(flash[:notice]).to_not be_nil
      end
    end
  end
end
