# Routes for client flags - issues that affect client usage of resources
class ClientFlagsController < ApplicationController
  before_filter :require_user

  # GET /client_flags
  def index
    authorize! :show, ClientFlag
    load_client_flags
  end

  # GET /client_flags/resolved
  def resolved
    authorize! :show, ClientFlag
    load_resolved_client_flags
  end

  def unresolved
    authorize! :show, ClientFlag
    load_unresolved_client_flags
  end

  # GET /client_flags/1
  def show
    authorize! :show, ClientFlag
    load_client_flag
  end

  # GET /client_flags/new
  def new
    authorize! :create, ClientFlag
    build_client_flag
  end

  # GET /client_flags/1/edit
  def edit
    authorize! :edit, ClientFlag
    @client_flag = ClientFlag.find(params[:id])
  end

  # POST /client_flags
  def create
    authorize! :create, ClientFlag
    params[:client_flag][:created_by] = current_user
    @client_flag = ClientFlag.new(params[:client_flag])

    if @client_flag.save
      redirect_to @client_flag,
        notice: 'Client flag was successfully created.'
    else
      render :new
    end
  end

  # PUT /client_flags/1
  def update
    authorize! :update, ClientFlag
    @client_flag = ClientFlag.find(params[:id])

    if @client_flag.update_attributes(params[:client_flag])
      redirect_to @client_flag,
        notice: 'Client flag was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /client_flags/1
  def destroy
    authorize! :destroy, ClientFlag
    @client_flag = ClientFlag.find(params[:id])
    @client_flag.destroy

    redirect_to client_flags_url
  end

  def resolve
    @client_flag = ClientFlag.find(params[:id])
  end

  def resolve_store
    @client_flag = ClientFlag.find(params[:id])
    @client_flag.resolved_by = current_user
    @client_flag.resolved_on = Date.today

    if @client_flag.save
      redirect_to @client_flag,
        notice: "Issue was resolved"
    else
      redirect_to @client_flag,
        notice: "Unable to resolve issue."
    end
  end

  private

  def load_client_flags
    @client_flags ||= ClientFlag.page params[:page]
  end

  def load_resolved_client_flags
    @client_flags ||= ClientFlag.resolved.page params[:page]
  end

  def load_unresolved_client_flags
    @client_flags ||= ClientFlag.unresolved.page params[:page]
  end

  def load_client_flag
    @client_flag ||= ClientFlag.find(params[:id])
  end

  def build_client_flag
    @client_flag ||= ClientFlag.new
  end
end
