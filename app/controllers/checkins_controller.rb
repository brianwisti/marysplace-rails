# Routes for client checkins - handy for usage counts and record keeping.
class CheckinsController < ApplicationController
  before_filter :require_user

  # GET /checkins
  def index
    authorize! :show, Checkin
    load_checkins
  end

  # GET /checkins/1
  def show
    authorize! :show, Checkin
    load_checkin
  end

  # GET /checkins/new
  def new
    authorize! :create, Checkin
    build_checkin
    load_locations
  end

  # GET /checkins/1/edit
  def edit
    authorize! :update, Checkin
    load_checkin
  end

  # POST /checkins
  def create
    authorize! :create, Checkin

    @checkin = Checkin.with_alternatives checkin_params,
      user: current_user,
      current_alias: params[:current_alias]

    save_checkin or render :new
  end

  # PUT /checkins/1
  def update
    authorize! :update, Checkin
    load_checkin
    update_checkin or render :edit
  end

  # DELETE /checkins/1
  def destroy
    authorize! :destroy, Checkin
    load_checkin
    @checkin.destroy

    redirect_to checkins_url
  end

  def today
    authorize! :show, Checkin

    @span = Date.today
    set_report_year
    @time_range = @span.strftime("%A, %B %d %Y")
    @checkins = Checkin.today

    render :daily_report
  end

  def annual_report
    authorize! :show, Checkin

    set_report_year
    load_report_rows
    count_reported_checkins
  end

  def monthly_report
    authorize! :show, Checkin

    set_report_year
    @month = params[:month].to_i
    @rows = Checkin.per_day_in(@year, @month)
    @total_checkins = @rows.inject(0) { |sum, row| sum += row.checkins.to_i }

    @span = Time.zone.local(@year, @month, 1, 0, 0)
    @time_range = @span.strftime("%B %Y")
  end

  def daily_report
    authorize! :show, Checkin

    set_report_year
    @month = params[:month].to_i
    @day   = params[:day].to_i
    @span = Time.zone.local(@year, @month, @day, 0, 0)
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
    checkin_code = params[:login]
    location   = Location.find(params[:location_id])
    checkin_at = Time.zone.now

    client = Client.where(checkin_code: checkin_code).first
    if client
      checkin = Checkin.new do |c|
        c.client     = client
        c.user       = current_user
        c.checkin_at = checkin_at
        c.location   = location
      end

      if checkin.valid?
        checkin.save
        flash[:notice] = "Checked in #{client.current_alias}"
      elsif checkin.errors[:client_id]
        flash[:alert] = "#{client.current_alias} #{checkin.errors[:client_id].join(', ')}"
      else
        flash[:alert] = "Unable to checkin #{client.current_alias}"
      end
    else
      flash[:alert] = "No client found for #{checkin_code}"
    end

    flash.keep
    redirect_to selfcheck_checkins_path
  end

  private

  def checkin_params
    params.require(:checkin).permit(:client_id, :user_id, :checkin_at, :notes, :location_id)
  end

  def load_checkins
    @checkins ||= Checkin.order('checkin_at DESC').page params[:page]
  end

  def load_checkin
    @checkin ||= Checkin.find(params[:id])
  end

  def build_checkin
    @checkin ||= Checkin.new
  end

  def load_locations
    @locations ||= Location.all
    @default_location ||= if current_user.checkins
                            current_user.checkins.last
                          else
                            @locations.first
                          end
  end

  def save_checkin
    if @checkin.save
      client = @checkin.client_current_alias
      redirect_to new_checkin_path,
        notice: "Checkin for #{client} was successfully created."
    end
  end

  def update_checkin
    if @checkin.update_attributes checkin_params
      redirect_to @checkin,
        notice: 'Checkin was successfully updated.'
    end
  end

  def set_report_year
    @year ||= if params[:year]
                params[:year].to_i
              else
                Date.today.year
              end
  end

  def load_report_rows
    @rows ||= Checkin.per_month_in @year
  end

  def count_reported_checkins
    @total_checkins ||= @rows.inject(0) { |sum, row| sum += row.checkins.to_i }
  end
end
