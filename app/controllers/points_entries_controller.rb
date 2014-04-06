# Allows users to log incentive points gained by performing chores,
# or points lost from purchases or bailing on chores.
class PointsEntriesController < ApplicationController
  before_filter :require_user

  def default_actions entry=nil
    actions = {
      "New Entry" => new_points_entry_url,
    }

    if entry
      actions["Change"] = edit_points_entry_url(entry)
    end

    return actions
  end

  # GET /points_entries
  def index
    @points_entries = PointsEntry.order("id DESC").page params[:page]
    @actions = default_actions
    @actions["Entry Types"] = points_entry_types_path
  end

  # GET /points_entries/1
  def show
    authorize! :show, PointsEntry
    @points_entry = PointsEntry.find(params[:id])
    @actions = default_actions(@points_entry)
  end

  # GET /points_entries/new
  def new
    @points_entry      = PointsEntry.new
    @client            = Client.new
    @points_entry_type = PointsEntryType.new
    @bail_penalty      = PointsEntry.bail_penalty
  end

  # GET /points_entries/1/edit
  def edit
    @points_entry      = PointsEntry.find(params[:id])
    @client            = @points_entry.client
    @points_entry_type = @points_entry.points_entry_type
    @bail_penalty      = PointsEntry.bail_penalty
  end

  # POST /points_entries
  def create
    params[:points_entry][:added_by_id] = current_user.id
    @points_entry = PointsEntry.new(params[:points_entry])

    unless @points_entry.client_id
      submitted_alias = params[:current_alias]
      client = Client.where('current_alias = ?', submitted_alias).first
      @points_entry.client = client if client
    end

    unless @points_entry.points_entry_type_id
      submitted_entry_type = params[:points_entry_type]
      entry_type = PointsEntryType.where(name: submitted_entry_type).first
      @points_entry.points_entry_type = entry_type if entry_type
    end

    if @points_entry.save
      redirect_to @points_entry,
        notice: 'Points entry was successfully created'
    else
      @client = @points_entry.client || Client.new
      @points_entry_type = @points_entry.points_entry_type ||
        PointsEntryType.new
      render :new
    end
  end

  # PUT /points_entries/1
  def update
    @points_entry = PointsEntry.find(params[:id])
    updated = @points_entry.update_attributes params[:points_entry]

    if updated
      redirect_to @points_entry,
        notice: 'Entry was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /points_entries/1
  def destroy
    @points_entry = PointsEntry.find(params[:id])
    @points_entry.destroy

    redirect_to points_entries_url
  end
end
