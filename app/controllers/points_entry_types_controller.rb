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
    @points_entry_type = PointsEntryType.find(params[:id])
    authorize! :update, @points_entry_type
  end

  # POST /points_entry_types
  # POST /points_entry_types.json
  def create
    authorize! :create, PointsEntryType
    @points_entry_type = PointsEntryType.new(params[:points_entry_type])

    respond_to do |format|
      if @points_entry_type.save
        format.html {
          redirect_to @points_entry_type,
            notice: 'Points entry type was successfully created.'
        }
        format.json {
          render json: @points_entry_type,
            status: :created, location: @points_entry_type
        }
      else
        format.html { render :new }
        format.json {
          render json: @points_entry_type.errors,
            status: :unprocessable_entity
        }
      end
    end
  end

  # PUT /points_entry_types/1
  # PUT /points_entry_types/1.json
  def update
    @points_entry_type = PointsEntryType.find(params[:id])
    authorize! :update, @points_entry_type

    respond_to do |format|
      if @points_entry_type.update_attributes(params[:points_entry_type])
        format.html {
          redirect_to @points_entry_type,
            notice: 'Points entry type was successfully updated.'
        }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json {
          render json: @points_entry_type.errors,
            status: :unprocessable_entity
        }
      end
    end
  end

  # DELETE /points_entry_types/1
  # DELETE /points_entry_types/1.json
  def destroy
    @points_entry_type = PointsEntryType.find(params[:id])
    authorize! :destroy, @points_entry_type

    @points_entry_type.destroy

    respond_to do |format|
      format.html { redirect_to points_entry_types_url }
      format.json { head :no_content }
    end
  end

  # GET /points_entry_types/1/entry
  # GET /points_entry_types/1/entry.json
  def entry
    authorize! :show, PointsEntryType
    authorize! :show, Client
    authorize! :create, PointsEntry

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
end
