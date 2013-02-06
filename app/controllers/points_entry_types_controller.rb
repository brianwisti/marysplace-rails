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
    @points_entry = PointsEntry.new
    @points_entry.points_entry_type = @points_entry_type
   
    respond_to do |format|
      format.html
    end
  end

  # GET /points_entry_types/1/report
  # GET /points_entry_types/1/report.json
  def report
    @points_entry_type = PointsEntryType.find(params[:id])
    @performed_on = params[:p] || ''

    # TODO: Replace with actual report generation
    @points_entries = @points_entry_type.points_entries

    if @performed_on != ''
      @points_entries = @points_entries.where(performed_on: @performed_on)
    else
      @start_date = @points_entries.first.performed_on
      @end_date = @points_entries.last.performed_on
      @monthly_points = @points_entries.sum_by_month(type: @points_entry_type.id,
                                                     from: @start_date,
                                                     to:   @end_date)
    end

    @count = @points_entries.count
    @total_points = @points_entries.sum(:points)

    respond_to do |format|
      format.html
    end
  end
end
