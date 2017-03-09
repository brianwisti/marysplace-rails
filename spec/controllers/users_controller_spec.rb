require 'rails_helper'

describe UsersController, :type => :controller do
  setup :activate_authlogic
  fixtures :roles, :users
  
  before do
    @attributes = {
      email: "waffle@example.com"
    }
  end

  context "admin user" do
    let(:admin_user) { users :admin }
    let(:user) { users :simple }
    let(:first_role) { roles :volunteer }
    let(:second_role) { roles :front_desk }

    before do
      login admin_user
    end

    after do
      logout admin_user
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
        user: @attributes,
        role_ids: role_ids
      expect(response).to redirect_to(user)
      loaded_user = assigns(:user)
      expect(loaded_user.roles.length).to eq(2)
    end

    it "can clear user roles" do
      user.accept_role first_role
      put :update, id: user,
        user: @attributes
      loaded_user = assigns(:user)
      expect(loaded_user.roles.length).to eq(0)
    end
  end
end
