class PasswordResetsController < ApplicationController
  before_filter :require_no_user, 
    only: [ :new ]
  before_filter :load_user_using_perishable_token, 
    only: [ :edit, :update ]

  # GET /password_resets/new
  def new
    render layout: 'bare'
  end

  # POST /
  def create
    login = params[:login]
    email = params[:email]

    if !login.empty?
      @user = User.where(login: login).first
    elsif !login.empty?
      @user = User.where(email: email).first
    end

    if @user
      @user.deliver_password_reset_instructions!
      @token = @user.perishable_token
      flash[:notice] = "reset token generated"
    else
      flash[:alert] = "Unable to find a user with that login or email"
    end

    render :new, layout: 'bare'
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
end
