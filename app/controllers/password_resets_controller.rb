class PasswordResetsController < ApplicationController
  before_filter :require_no_user,
    only: [ :new ]
  before_filter :load_user_using_perishable_token,
    only: [ :edit, :update ]

  def index
    redirect_to action: :new
  end

  # GET /password_resets/new
  def new
    render layout: 'bare'
  end

  # POST /
  def create
    load_user
    start_password_reset or render(:new,
                                   layout: 'bare',
                                   alert: "Unable to find user")
  end

  def edit
    render layout: 'bare'
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Password successfully updated"
      redirect_to current_user
    else
      render :action => :edit
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account. " +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to root_url
    end
  end

  def load_user
    login = params[:login]
    email = params[:email]

    if !login.empty?
      @user = User.where(login: login).first
    elsif !email.empty?
      @user = User.where(email: email).first
    end
  end

  def start_password_reset
    if @user
      @user.deliver_password_reset_instructions
      flash[:notice] = "Check your email for a link to reset your password."
      redirect_to login_url
    end
  end
end
