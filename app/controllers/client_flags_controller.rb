class ClientFlagsController < ApplicationController
  before_filter :require_user

  # GET /client_flags
  # GET /client_flags.json
  def index
    @client_flags = ClientFlag.order("id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @client_flags }
    end
  end

  def resolved
    @client_flags = ClientFlag.resolved.order("id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @client_flags }
    end
  end

  def unresolved
    @client_flags = ClientFlag.unresolved.order("id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @client_flags }
    end
  end

  # GET /client_flags/1
  # GET /client_flags/1.json
  def show
    @client_flag = ClientFlag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client_flag }
    end
  end

  # GET /client_flags/new
  # GET /client_flags/new.json
  def new
    @client_flag = ClientFlag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client_flag }
    end
  end

  # GET /client_flags/1/edit
  def edit
    @client_flag = ClientFlag.find(params[:id])
  end

  # POST /client_flags
  # POST /client_flags.json
  def create
    params[:client_flag][:created_by] = current_user
    @client_flag = ClientFlag.new(params[:client_flag])

    respond_to do |format|
      if @client_flag.save
        format.html { redirect_to @client_flag, notice: 'Client flag was successfully created.' }
        format.json { render json: @client_flag, status: :created, location: @client_flag }
      else
        format.html { render action: "new" }
        format.json { render json: @client_flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /client_flags/1
  # PUT /client_flags/1.json
  def update
    @client_flag = ClientFlag.find(params[:id])

    respond_to do |format|
      if @client_flag.update_attributes(params[:client_flag])
        format.html { redirect_to @client_flag, notice: 'Client flag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @client_flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_flags/1
  # DELETE /client_flags/1.json
  def destroy
    @client_flag = ClientFlag.find(params[:id])
    @client_flag.destroy

    respond_to do |format|
      format.html { redirect_to client_flags_url }
      format.json { head :no_content }
    end
  end

  def resolve
    @client_flag = ClientFlag.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def resolve_store
    @client_flag = ClientFlag.find(params[:id])
    @client_flag.resolved_by = current_user
    @client_flag.resolved_on = Date.today

    respond_to do |format|
      if @client_flag.save
        format.html { redirect_to @client_flag, notice: "Issue was resolved" }
      else
        format.html { redirect_to @client_flag, notice: "Unable to resolve issue."  }
      end
    end
  end
end
