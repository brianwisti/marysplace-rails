class UsersController < ApplicationController
  before_filter :require_user

  def index
    authorize! :manage, User
    @users = User.order('login ASC')
    @roles = Role.order(:name)
  end

  def new
    authorize! :create, User
    @user = User.new
  end

  def create
    authorize! :create, User

    @user = User.new(params[:user])

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
    end
  end

  def update
    @user = User.find(params[:id])

    if @user != @current_user
      authorize! :manage, User
    end

    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to @user
    else
      render :edit
    end
  end

  def toggle_role
    authorize! :manage, User
    user = User.find(params[:id])
    role = Role.find(params[:role_id])

    user.toggle_role role
    message = "#{role.name} toggled for #{user.login}"
    flash[:notice] = message

    @result = {
      result: message
    }

    respond_to do |format|
      format.html { redirect_to users_path }
      format.json { render json: @result  }
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
end
