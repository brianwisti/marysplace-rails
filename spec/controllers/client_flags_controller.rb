require 'rails_helper'

describe ClientFlagsController do
  setup :activate_authlogic

  context "anonymous access" do
    let(:user) { create :user }

    before do
      login user
    end

    describe "index" do
      it "should be unavailable" do
        get :index
        expect_login response
        expect(assigns(:flags)).to be_nil
      end
    end

    describe "resolved" do
      it "should be unavailable" do
        get :resolved
        expect_login response
        expect(assigns(:flags)).to be_nil
      end
    end
  end

  context "staff access" do
    let(:staff_user)      { create :staff_user }
    let(:unresolved_flag) { create :client_flag }
    let(:resolved_flag)   { create :resolved_flag }

    before do
      login staff_user
    end

    describe "index" do
      it "should be available" do
        get :index
        expect(response).to render_template(:index)
      end

      it "should present some ClientFlags" do
        get :index
        expect(assigns(:flags).length).to eql(2)
      end
    end

    describe "resolved" do
      it "should be available" do
        get :resolved
        expect(response).to render_template(:resolved)
      end
    end

    describe "show" do
      before { get :show, id: unresolved_flag }

      it "should be available" do
        expect(response).to render_template(:show)
      end

      it "should present a ClientFlag" do
        expect(assigns(:client_flag)).to be(unresolved)
      end
    end
  end
end
