# Allows users to log incentive points gained by performing chores,
# or points lost from purchases or bailing on chores.
class PointsEntriesController < ApplicationController
  before_filter :require_user

  # GET /points_entries
  def index
    load_points_entries
  end

  # GET /points_entries/1
  def show
    authorize! :show, PointsEntry
    load_points_entry
  end

  # GET /points_entries/new
  def new
    build_points_entry
  end

  # GET /points_entries/1/edit
  def edit
    load_points_entry
    build_points_entry
  end

  # POST /points_entries
  def create
    build_points_entry
    save_points_entry or render :new
  end

  # PUT /points_entries/1
  def update
    load_points_entry
    build_points_entry
    save_points_entry or render :edit
  end

  # DELETE /points_entries/1
  def destroy
    load_points_entry
    destroy_points_entry

    redirect_to points_entries_url
  end

  private

  def points_entry_params
    points_entry_params = params[:points_entry]

    if points_entry_params
      points_entry_params.permit(:client_id,
                                 :points_entry_type_id,
                                 :performed_on,
                                 :bailed,
                                 :added_by_id,
                                 :location_id,
                                 :multiple,
                                 :points_entered)
    else
      {}
    end
  end

  def load_points_entries
    @points_entries ||= PointsEntry.order("id DESC").page params[:page]
  end

  def load_points_entry
    @points_entry ||= PointsEntry.find(params[:id])
  end

  def build_points_entry
    @points_entry            ||= PointsEntry.new
    @points_entry.attributes   = points_entry_params
    @points_entry.added_by   ||= current_user

    if !@points_entry.client_id and submitted_alias = params[:current_alias]
      client = Client.where('current_alias = ?', submitted_alias).first
      @points_entry.client = client if client
    end

    if !@points_entry.points_entry_type_id and submitted_entry_type = params[:points_entry_type]
      entry_type = PointsEntryType.where(name: submitted_entry_type).first
      @points_entry.points_entry_type = entry_type if entry_type
    end
  end

  def save_points_entry
    if @points_entry.save
      redirect_to @points_entry,
        notice: 'Points entry was successfully created'
    end
  end

  def destroy_points_entry
    @points_entry.destroy
  end
end
