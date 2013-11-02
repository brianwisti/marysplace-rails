# Allows users to log incentive points gained by performing chores,
# or points lost from purchases or bailing on chores.
class PointsEntriesController < ApplicationController
  before_filter :require_user

  # GET /points_entries
  # GET /points_entries.json
  def index
    @points_entries = PointsEntry.order("id DESC").page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @points_entries }
    end
  end

  # GET /points_entries/1
  # GET /points_entries/1.json
  def show
    authorize! :show, PointsEntry
    @points_entry = PointsEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @points_entry }
    end
  end

  # GET /points_entries/new
  # GET /points_entries/new.json
  def new
    @points_entry = PointsEntry.new
    @client = Client.new
    @points_entry_type = PointsEntryType.new
    @bail_penalty = PointsEntry.bail_penalty

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @points_entry }
    end
  end

  # GET /points_entries/1/edit
  def edit
    @points_entry = PointsEntry.find(params[:id])
    @client = @points_entry.client
    @points_entry_type = @points_entry.points_entry_type
    @bail_penalty = PointsEntry.bail_penalty
  end

  # POST /points_entries
  # POST /points_entries.json
  def create
    params[:points_entry][:added_by_id] = current_user.id
    @points_entry = PointsEntry.new(params[:points_entry])

    respond_to do |format|
      if @points_entry.save
        format.html {
          redirect_to @points_entry,
            notice: 'Points entry was successfully created'
        }
        format.json {
          render json: @points_entry,
            status: :created, location: @points_entry
        }
      else
        format.html { render :new }
        format.json {
          render json: @points_entry.errors,
            status: :unprocessable_entity
        }
      end
    end
  end

  # PUT /points_entries/1
  # PUT /points_entries/1.json
  def update
    @points_entry = PointsEntry.find(params[:id])

    respond_to do |format|
      if @points_entry.update_attributes(params[:points_entry])
        format.html {
          redirect_to @points_entry,
            notice: 'Points entry was successfully updated.'
        }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json {
          render json: @points_entry.errors,
            status: :unprocessable_entity
        }
      end
    end
  end

  # DELETE /points_entries/1
  # DELETE /points_entries/1.json
  def destroy
    @points_entry = PointsEntry.find(params[:id])
    @points_entry.destroy

    respond_to do |format|
      format.html { redirect_to points_entries_url }
      format.json { head :no_content }
    end
  end
end
