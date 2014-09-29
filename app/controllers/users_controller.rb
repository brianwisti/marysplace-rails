class UsersController < ApplicationController
  before_filter :require_user

  def index
    authorize! :manage, User
    load_users
    load_roles
  end

  def new
    authorize! :create, User
    @user = User.new
    site_admin_role = 'site_admin'
    @roles = if current_user.role? site_admin_role
               Role.all.load.to_a
             else
               Role.org_roles.load.to_a
             end
  end

  def create
    authorize! :create, User

    @user = User.new user_params

    if @user.save
      flash[:notice] = "User created!"
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @roles = Role.order(:name)

    # Anyone can view themselves, but all else requires auth.
    if @user != @current_user
      authorize! :show, User
    end
  end

  def edit
    @user = User.find(params[:id])

    if @user != @current_user
      authorize! :manage, User
      site_admin_role = 'site_admin'
      @roles = if current_user.role? site_admin_role
                 Role.all
               else
                 Role.where 'name != ?', site_admin_role
               end
    end
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
    params.require(:user).permit(:name, :login, :password, :password_confirmation,
                                :email, :organization_id)
  end

  def load_users
    @users ||= User.order 'login ASC'
  end

  def load_roles
    @roles ||= Role.order :name
  end
end
