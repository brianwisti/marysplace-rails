class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  def index
    authorize! :manage, User
    @users = User.order('login ASC')
    @roles = Role.order(:name)
  end

  def new
    @user = User.new
  end

  def create

    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default root_path
    else
      render :action => :new
    end
  end

  def show
    @user = User.find(params[:id])

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
    if params[:id]
      authorize! :manage, User
      @user = User.find(params[:id])
    else
      @user = @current_user # makes our views "cleaner" and more consistent
    end

    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render action: :edit
    end
  end

  def toggle_role
    authorize! :manage, User
    user = User.find(params[:id])
    role = Role.find(params[:role_id])

    if user and role 
      if user.roles.include? role
        if user.roles.delete(role)
          message = "#{user.login} is no longer #{role.name}"
        else
          message = "Unable to remove #{user.login} from #{role.name}"
        end
      else
        if user.roles.push(role)
          message = "#{user.login} is now #{role.name}"
        else
          message = "Unable to make #{user.login} a #{role.name}"
        end
      end

      @result = {
        result: message
      }

      render json: @result
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
