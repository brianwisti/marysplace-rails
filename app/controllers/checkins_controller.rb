class CheckinsController < ApplicationController
  before_filter :require_user

  # GET /checkins
  # GET /checkins.json
  def index
    @checkins = Checkin.order('checkin_at DESC').page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @checkins }
    end
  end

  # GET /checkins/1
  # GET /checkins/1.json
  def show
    @checkin = Checkin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @checkin }
    end
  end

  # GET /checkins/new
  # GET /checkins/new.json
  def new
    @checkin = Checkin.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @checkin }
    end
  end

  # GET /checkins/1/edit
  def edit
    @checkin = Checkin.find(params[:id])
  end

  # POST /checkins
  # POST /checkins.json
  def create
    params[:checkin][:user_id] = current_user.id
    @checkin = Checkin.new(params[:checkin])

    @checkin.checkin_at ||= DateTime.now

    respond_to do |format|
      if @checkin.save
        format.html { redirect_to new_checkin_path, notice: "Checkin for #{@checkin.client.current_alias} was successfully created." }
        format.json { render json: @checkin, status: :created, location: @checkin }
      else
        format.html { render action: "new" }
        format.json { render json: @checkin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /checkins/1
  # PUT /checkins/1.json
  def update
    @checkin = Checkin.find(params[:id])

    respond_to do |format|
      if @checkin.update_attributes(params[:checkin])
        format.html { redirect_to @checkin, notice: 'Checkin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @checkin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /checkins/1
  # DELETE /checkins/1.json
  def destroy
    @checkin = Checkin.find(params[:id])
    @checkin.destroy

    respond_to do |format|
      format.html { redirect_to checkins_url }
      format.json { head :no_content }
    end
  end

  def on
    @year = params[:year].to_i
    @month = params[:month].to_i
    @day = params[:day].to_i
    @checkin_date = Date.new(@year, @month, @day)
    today = Date.today

    if @checkin_date < today
      @tomorrow = @checkin_date + 1.day
    end

    @yesterday = @checkin_date - 1.day
    @checkins = Checkin.on(@checkin_date)
  end

  def today
    today = Date.today
    @checkins = Checkin.today
    @yesterday = today - 1.day
  end

  def report
    now = Time.now.in_time_zone
    @year = params[:year] || now.year
    @year = @year.to_i
    @month = params[:month].to_i
    @day = params[:day].to_i

    if @month > 0
      if @day > 0
        @span = DateTime.new(@year, @month, @day, 0, 0)
        @checkins = Checkin.where('checkin_at > ?', @span)
        @last_day = @span - 1.day
        @next_day = @span + 1.day
      else
        @span = DateTime.new(@year, @month, 1, 0, 0)
        @rows = Checkin.per_day_in(@year, @month)
      end

      @last_month = @span - 1.month
      @next_month = @span + 1.month
    else
      @span = DateTime.new(@year, 1, 1, 0, 0)
      @rows = Checkin.per_month_in(@year)
    end

    @last_year = @span - 1.year
    @next_year = @span + 1.year

    if @row
      @total_checkins = @rows.inject(0) { |sum, row| sum += row.checkins.to_i }
    end

    respond_to do |format|
      format.html
    end
  end

  def selfcheck
    authorize! :create, Checkin
  end

  def selfcheck_post
    authorize! :create, Checkin
    login_code = params[:login]
    checkin_at = DateTime.now

    login = User.find_by_login login_code
    if login and login.client
      checkin = Checkin.create(client_id: login.client.id, user_id: current_user.id, checkin_at: checkin_at)
      if checkin
        flash[:notice] = "#{checkin_at}: #{login.client.current_alias}"
      else
        flash[:alert] = "#{checkin_at}: Unable to checkin #{login.client.current_alias}"
      end
    else
      flash[:alert] = "No client found for #{login_code}"
    end

    flash.keep
    redirect_to selfcheck_checkins_path
  end
end
