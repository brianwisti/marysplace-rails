require 'spec_helper'

describe UsersController do
  fixtures :users, :roles
  setup :activate_authlogic

  context "admin user" do
    let(:admin_user) { users :admin_user }
    let(:user) { users :basic_user }
    let(:first_role) { roles :staff }
    let(:second_role) { roles :front_desk }

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
        role_ids: role_ids
      expect(response).to redirect_to(user)
      loaded_user = assigns(:user)
      expect(loaded_user.roles.length).to eq(2)
    end

    it "can clear user roles" do
      user.accept_role first_role
      put :update, id: user
      loaded_user = assigns(:user)
      expect(loaded_user.roles.length).to eq(0)
    end
  end
end
