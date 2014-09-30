require 'spec_helper'

describe UsersController, :type => :controller do
  setup :activate_authlogic

  context "admin user" do
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }
    let(:first_role) { create :role }
    let(:second_role) { create :role }

    before do
      login admin_user
    end

    it "can access any user page" do
      get :show, id: user
      expect(response).to render_template(:show)
    end

    it "can edit a user" do
      get :edit, id: user
      expect(response).to render_template(:edit)
      expect(assigns(:roles)).to_not be(nil)
    end

    it "can set user roles" do
      role_ids = [ first_role.id, second_role.id ]
      put :update, id: user,
        user: attributes_for(:user),
        role_ids: role_ids
      expect(response).to redirect_to(user)
      loaded_user = assigns(:user)
      expect(loaded_user.roles.length).to eq(2)
    end

    it "can clear user roles" do
      user.accept_role first_role
      put :update, id: user,
        user: attributes_for(:user)
      loaded_user = assigns(:user)
      expect(loaded_user.roles.length).to eq(0)
    end
  end
end
