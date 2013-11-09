class CheckinsController < ApplicationController
  before_filter :require_user

  # GET /checkins
  def index
    authorize! :show, Checkin
    @checkins = Checkin.order('checkin_at DESC').page params[:page]
  end

  # GET /checkins/1
  def show
    authorize! :show, Checkin

    @checkin = Checkin.find(params[:id])
  end

  # GET /checkins/new
  def new
    authorize! :create, Checkin
    @checkin = Checkin.new
    @locations = Location.all

    last_checkin = current_user.checkins.last

    if last_checkin
      @default_location = last_checkin.location
    else
      @default_location = @locations.first
    end
  end

  # GET /checkins/1/edit
  def edit
    authorize! :update, Checkin
    @checkin = Checkin.find(params[:id])
  end

  # POST /checkins
  def create
    authorize! :create, Checkin

    @checkin = Checkin.with_alternatives params[:checkin],
      user: current_user,
      current_alias: params[:current_alias]

    if @checkin.save
      client = @checkin.client_current_alias
      redirect_to new_checkin_path,
      notice: "Checkin for #{client} was successfully created."
    else
      render :new
    end
  end

  # PUT /checkins/1
  def update
    authorize! :update, Checkin

    @checkin = Checkin.find(params[:id])

    if @checkin.update_attributes(params[:checkin])
      redirect_to @checkin, notice: 'Checkin was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /checkins/1
  def destroy
    authorize! :destroy, Checkin

    @checkin = Checkin.find(params[:id])
    @checkin.destroy

    redirect_to checkins_url
  end

  def today
    authorize! :show, Checkin

    @span = Date.today
    @year = @span.year
    @rows = Checkin.today

    render :daily_report
  end

  def annual_report
    authorize! :show, Checkin

    @year = params[:year].to_i
    @rows = Checkin.per_month_in(@year)
    @total_checkins = @rows.inject(0) { |sum, row| sum += row.checkins.to_i }
  end

  def monthly_report
    authorize! :show, Checkin

    @year = params[:year].to_i
    @month = params[:month].to_i
    @rows = Checkin.per_day_in(@year, @month)
    @total_checkins = @rows.inject(0) { |sum, row| sum += row.checkins.to_i }

    @span = DateTime.new(@year, @month, 1, 0, 0)
    @time_range = @span.strftime("%B %Y")
  end

  def daily_report
    authorize! :show, Checkin

    @year  = params[:year].to_i
    @month = params[:month].to_i
    @day   = params[:day].to_i
    @span = DateTime.new(@year, @month, @day, 0, 0)
    @time_range = @span.strftime("%A, %B %d %Y")
    @checkins = Checkin.on(@span)
    @total_checkins = @checkins.count
  end

  def selfcheck
    authorize! :create, Checkin
    @checkins = Checkin.today.order('checkin_at DESC')
    @locations = Location.all

    last_checkin = current_user.checkins.last

    if last_checkin
      @default_location = last_checkin.location
    else
      @default_location = @locations.first
    end
  end

  def selfcheck_post
    authorize! :create, Checkin
    login_code = params[:login]
    location   = Location.find(params[:location_id])
    checkin_at = DateTime.now

    login = User.find_by_login login_code
    if login and login.client
      checkin = Checkin.create! do |c|
        c.client     = login.client
        c.user       = current_user
        c.checkin_at = checkin_at
        c.location   = location
      end

      if checkin
        flash[:notice] = "Checked in #{login.client.current_alias}"
      else
        flash[:alert] = "Unable to checkin #{login.client.current_alias}"
      end
    else
      flash[:alert] = "No client found for #{login_code}"
    end

    flash.keep
    redirect_to selfcheck_checkins_path
  end
end
