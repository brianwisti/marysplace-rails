class UsersController < ApplicationController
  before_filter :require_user

  def index
    authorize! :manage, User
    load_users
    load_roles
  end

  def new
    authorize! :create, User
    build_user
    load_assignable_roles
  end

  def create
    authorize! :create, User
    build_user
    save_user or render :new
  end

  def show
    load_user
    load_roles
  end

  def edit
    load_user
    build_user
  end

  # The U in CRUD
  #
  # User forms include a list of roles that this user has accepted
  def update
    @user = User.find(params[:id])

    if @user != @current_user
      authorize! :manage, User
      roles = []
      role_ids = params[:role_ids]

      if role_ids
        roles = Role.find role_ids
      end

      @user.establish_roles roles
    end

    if @user.update_attributes user_params
      flash[:notice] = "Account updated!"
      redirect_to @user
    else
      render :edit
    end
  end

  def entries
    @user = User.find(params[:id])

    # Anyone can view themselves, but all else requires auth.
    if @user != @current_user
      authorize! :show, User
    end

    @entries = @user.points_entries.order('performed_on DESC, id DESC').page params[:page]
  end

  def preference
    @user = User.find(params[:id])
    group = params[:section]
    submitted = params[:group]
    settings = submitted.find_all { |k,v| v == "on" }.map { |i| i[0] }

    if @user.remember_preference( group => settings )
      flash[:notice] = "Preference updated!"
    else
      flash[:error] = "Unable to update preference!"
    end

    redirect_to clients_path
  end

  private

  def user_params
    user_params = params[:user]

    if user_params
      user_params.permit(:name, :login, :password, :password_confirmation,
                         :email, :organization_id)
    else
      {}
    end
  end

  def load_users
    @users ||= User.order 'login ASC'
  end

  def load_user
    @user ||= User.find(params[:id])

    # Anyone can view themselves, but all else requires auth.
    if @user != @current_user
      authorize! :show, User
    end
  end

  def load_roles
    @roles ||= Role.order :name
  end

  def load_assignable_roles
    site_admin_role = 'site_admin'
    @roles ||= if current_user.role? site_admin_role
                 Role.all.load.to_a
               else
                 Role.org_roles.load.to_a
               end
  end

  def build_user
    @user ||= User.new
    @user.attributes = user_params

    if @user != @current_user
      authorize! :manage, User
      load_assignable_roles
    end
  end

  def save_user
    if @user.save
      redirect_to @user, notice: "User created!"
    end
  end
end
