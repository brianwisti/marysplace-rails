class CheckinsController < ApplicationController
  before_filter :require_user

  # GET /checkins
  # GET /checkins.json
  def index
    authorize! :show, Checkin
    @checkins = Checkin.order('checkin_at DESC').page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @checkins }
    end
  end

  # GET /checkins/1
  # GET /checkins/1.json
  def show
    authorize! :show, Checkin

    @checkin = Checkin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @checkin }
    end
  end

  # GET /checkins/new
  # GET /checkins/new.json
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @checkin }
    end
  end

  # GET /checkins/1/edit
  def edit
    authorize! :update, Checkin
    @checkin = Checkin.find(params[:id])
  end

  # POST /checkins
  # POST /checkins.json
  def create
    authorize! :create, Checkin

    params[:checkin][:user_id] = current_user.id
    @checkin = Checkin.new(params[:checkin])

    unless @checkin.client
      current_alias = params[:current_alias]
      @checkin.client = Client.where(current_alias: current_alias).first
    end

    @checkin.checkin_at ||= DateTime.now

    respond_to do |format|
      if @checkin.save
        format.html {
          client = @checkin.client_current_alias
          redirect_to new_checkin_path,
          notice: "Checkin for #{client} was successfully created."
        }
        format.json {
          render json: @checkin, status: :created, location: @checkin
        }
      else
        format.html { render :new }
        format.json {
          render json: @checkin.errors, status: :unprocessable_entity
        }
      end
    end
  end

  # PUT /checkins/1
  # PUT /checkins/1.json
  def update
    authorize! :update, Checkin

    @checkin = Checkin.find(params[:id])

    respond_to do |format|
      if @checkin.update_attributes(params[:checkin])
        format.html {
          redirect_to @checkin, notice: 'Checkin was successfully updated.'
        }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json {
          render json: @checkin.errors, status: :unprocessable_entity
        }
      end
    end
  end

  # DELETE /checkins/1
  # DELETE /checkins/1.json
  def destroy
    authorize! :destroy, Checkin

    @checkin = Checkin.find(params[:id])
    @checkin.destroy

    respond_to do |format|
      format.html { redirect_to checkins_url }
      format.json { head :no_content }
    end
  end

  def today
    authorize! :show, Checkin

    @span = Date.today
    @year = @span.year
    @rows = Checkin.today

    respond_to do |format|
      format.html { render 'daily_report' }
    end
  end

  def annual_report
    authorize! :show, Checkin

    @year = params[:year].to_i
    @rows = Checkin.per_month_in(@year)
    @total_checkins = @rows.inject(0) { |sum, row| sum += row.checkins.to_i }

    respond_to do |format|
      format.html
    end
  end

  def monthly_report
    authorize! :show, Checkin

    @year = params[:year].to_i
    @month = params[:month].to_i
    @rows = Checkin.per_day_in(@year, @month)
    @total_checkins = @rows.inject(0) { |sum, row| sum += row.checkins.to_i }

    @span = DateTime.new(@year, @month, 1, 0, 0)
    @time_range = @span.strftime("%B %Y")

    respond_to do |format|
      format.html
    end
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

    respond_to do |format|
      format.html
    end
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
