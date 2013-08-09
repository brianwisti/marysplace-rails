class PointsEntryTypesController < ApplicationController
  before_filter :require_user

  # GET /points_entry_types
  # GET /points_entry_types.json
  def index
    @points_entry_types = PointsEntryType.order('name').all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @points_entry_types }
    end
  end

  # GET /points_entry_types/search
  # GET /points_entry_types/search.json
  def search
    @query = params[:q]
    @points_entry_types = PointsEntryType.quicksearch(@query)

    respond_to do |format|
      #format.html # actually, no.
      format.json {
        render json: @points_entry_types.select([:id, :name, :default_points])
      }
    end
  end

  # GET /points_entry_types/1
  # GET /points_entry_types/1.json
  def show
    @points_entry_type = PointsEntryType.find(params[:id])
    @points_entries = @points_entry_type.points_entries
      .order('performed_on DESC')
      .page(params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @points_entry_type }
    end
  end

  # GET /points_entry_types/new
  # GET /points_entry_types/new.json
  def new
    @points_entry_type = PointsEntryType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @points_entry_type }
    end
  end

  # GET /points_entry_types/1/edit
  def edit
    @points_entry_type = PointsEntryType.find(params[:id])
  end

  # POST /points_entry_types
  # POST /points_entry_types.json
  def create
    @points_entry_type = PointsEntryType.new(params[:points_entry_type])

    respond_to do |format|
      if @points_entry_type.save
        format.html { redirect_to @points_entry_type, notice: 'Points entry type was successfully created.' }
        format.json { render json: @points_entry_type, status: :created, location: @points_entry_type }
      else
        format.html { render action: "new" }
        format.json { render json: @points_entry_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /points_entry_types/1
  # PUT /points_entry_types/1.json
  def update
    @points_entry_type = PointsEntryType.find(params[:id])

    respond_to do |format|
      if @points_entry_type.update_attributes(params[:points_entry_type])
        format.html { redirect_to @points_entry_type, notice: 'Points entry type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @points_entry_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /points_entry_types/1
  # DELETE /points_entry_types/1.json
  def destroy
    @points_entry_type = PointsEntryType.find(params[:id])
    @points_entry_type.destroy

    respond_to do |format|
      format.html { redirect_to points_entry_types_url }
      format.json { head :no_content }
    end
  end

  # GET /points_entry_types/1/entry
  # GET /points_entry_types/1/entry.json
  def entry
    @points_entry_type = PointsEntryType.find(params[:id])
    @client = Client.new
    @points_entry = PointsEntry.new do |entry|
      entry.points_entry_type = @points_entry_type
      entry.points            = @points_entry_type.default_points
    end
   
    respond_to do |format|
      format.html
    end
  end

  # GET /points_entry_types/1/report
  # GET /points_entry_types/1/report.json
  def report
    @points_entry_type = PointsEntryType.find(params[:id])
    now = Date.today
    @year = params[:year] || now.year
    @year = @year.to_i
    @month = params[:month].to_i
    @day = params[:day].to_i

    if @month > 0
      if @day > 0
        @span = Date.new(@year, @month, @day)
        @entries = @points_entry_type.points_entries.where('performed_on = ?', @span)
        @last_day = @span - 1.day
        @next_day = @span + 1.day
        @total_points = @entries.inject(0) { |sum, entry| sum += entry.points }
        @total_entries = @entries.length
      else
        @span = Date.new(@year, @month, 1)
        @rows = @points_entry_type.points_entries.per_day_in(@year, @month)
      end

      @last_month = @span - 1.month
      @next_month = @span + 1.month
    else
      @span = Date.new(@year, 1, 1)
      @rows = @points_entry_type.points_entries.per_month_in(@year)
    end

    @last_year = @span - 1.year
    @next_year = @span + 1.year

    if @rows
      @total_points = @rows.inject(0)  { |sum, row| sum += row.points }
      @total_entries = @rows.inject(0) { |sum, row| sum += row.entries.to_i }
    end

    respond_to do |format|
      format.html
    end
  end

  def signup_lists
    @points_entry_type = PointsEntryType.find(params[:id].to_i)
    @signup_lists = @points_entry_type.signup_lists

    respond_to do |format|
      format.html
    end
  end

  def create_signup_list
    @points_entry_type = PointsEntryType.find(params[:id].to_i)
    @signup_list = SignupList.new(params[:signup_list])

    respond_to do |format|
      if @signup_list.save
        format.html { redirect_to @signup_list, notice: 'Signup List was successfully created.' }
        format.json { render json: @signup_list, status: :created, location: @signup_list }
      else
        format.html { render action: "new" }
        format.json { render json: @signup_list.errors, status: :unprocessable_entity }
      end
    end
  end
end
