class PointsEntryTypesController < ApplicationController
  before_filter :require_user

  # GET /points_entry_types
  # GET /points_entry_types.json
  def index
    authorize! :show, PointsEntryType
    @points_entry_types = PointsEntryType.active.order('name')

    respond_to do |format|
      format.html do
        @points_entry_types = @points_entry_types.page params[:page]
      end

      format.json { render json: @points_entry_types }
    end
  end

  def all
    authorize! :show, PointsEntryType
    @points_entry_types = PointsEntryType.order('name').page params[:page]
  end

  # GET /points_entry_types/search
  # GET /points_entry_types/search.json
  def search
    authorize! :show, PointsEntryType
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
    authorize! :show, PointsEntryType
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
    authorize! :create, PointsEntryType
    @points_entry_type = PointsEntryType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @points_entry_type }
    end
  end

  # GET /points_entry_types/1/edit
  def edit
    load_points_entry_type
    authorize! :update, @points_entry_type
  end

  # POST /points_entry_types
  # POST /points_entry_types.json
  def create
    authorize! :create, PointsEntryType
    build_points_entry_type
    save_points_entry_type or render :new
  end

  # PUT /points_entry_types/1
  # PUT /points_entry_types/1.json
  def update
    load_points_entry_type
    authorize! :update, @points_entry_type
    build_points_entry_type
    save_points_entry_type or redirect_to :edit
  end

  # DELETE /points_entry_types/1
  # DELETE /points_entry_types/1.json
  def destroy
    load_points_entry_type
    authorize! :destroy, @points_entry_type
    destroy_points_entry_type
  end

  # GET /points_entry_types/1/entry
  # GET /points_entry_types/1/entry.json
  def entry
    authorize! :show, PointsEntryType
    authorize! :show, Client
    authorize! :create, PointsEntry

    load_points_entry_type
    build_client
    build_points_entry
  end

  private

  def points_entry_type_params
    params[:points_entry_type] || {}
  end

  def load_points_entry_type
    @points_entry_type ||= PointsEntryType.find params[:id]
  end

  def build_points_entry_type
    @points_entry_type ||= PointsEntryType.new
    @points_entry_type.attributes = points_entry_type_params
  end

  def save_points_entry_type
    if @points_entry_type.save
      redirect_to @points_entry_type
    end
  end

  def destroy_points_entry_type
    @points_entry_type.destroy
  end

  def build_client
    @client ||= Client.new
  end

  def build_points_entry
    @points_entry ||= PointsEntry.new do |entry|
      entry.points_entry_type = @points_entry_type
      entry.points            = @points_entry_type.default_points
    end
  end
end
