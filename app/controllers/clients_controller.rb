# /clients
class ClientsController < ApplicationController
  before_filter :require_user
  helper_method :sort_column, :sort_direction

  # GET /all
  # GET /all.json
  def all
    sort_rule = "#{sort_column} #{sort_direction}"
    @clients = Client.order(sort_rule).page params[:page]
  end

  # GET /clients
  # GET /clients.json
  def index
    sort_rule = "#{sort_column} #{sort_direction}"
    @clients = Client.where(is_active: true)
        .order(sort_rule).page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end

  # GET /search
  # GET /search.json
  def search
    @query = params[:q]
    @clients = Client.quicksearch(@query)
    mapping = @clients.map do |c|
      { id: c.id,
        current_alias: c.current_alias,
        other_aliases: c.other_aliases,
        point_balance: c.point_balance,
        is_flagged:    c.is_flagged?,
        can_shop:      c.can_shop?
      }
    end

    respond_to do |format|
      format.html # search.html.haml
      format.json {
        render json: mapping
      }
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
    end
  end

  def entry
    @client = Client.find(params[:id])
    @points_entry = PointsEntry.new
    @points_entry_type = PointsEntryType.new
    @points_entry.client = @client

    respond_to do |format|
      format.html # entry.html.haml
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(params[:client])
    @client.added_by_id = current_user.id

    respond_to do |format|
      if @client.save
        format.html {
          redirect_to @client, notice: 'Client was successfully created.'
        }
        format.json {
          render json: @client, status: :created, location: @client
        }
      else
        format.html { render :new }
        format.json {
          render json: @client.errors, status: :unprocessable_entity
        }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html {
          redirect_to @client, notice: 'Client was successfully updated.'
      }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json {
          render json: @client.errors, status: :unprocessable_entity
        }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end

  # GET /clients/1/entries
  # GET /clients/1/entries.json
  def entries
    @client = Client.find(params[:id])
    @entries = @client.points_entries.page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @entries }
    end
  end

  def checkins
    @client = Client.find(params[:id])
    @checkins = @client.checkins.order('checkin_at DESC').page params[:page]
    respond_to do |format|
      format.html
      format.json { render json: @entries }
    end
  end

  def flags
    @client = Client.find(params[:id])
    @flags = @client.client_flags.order('expires_on DESC')

    respond_to do |format|
      format.html
      format.json { render json: @flags }
    end
  end

  def new_login
    authorize! :create, User
    @client = Client.find(params[:id])
  end

  def create_login
    authorize! :create, User
    @client = Client.find(params[:id])
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    if password == password_confirmation
      @client.create_login(password: password,
                           password_confirmation: password_confirmation)
      if @client.login
        flash[:notice] = "Login created"
      end
    else
      flash[:error] = "Password and confirmation do not match"
    end


    respond_to do |format|
      format.html do
        if @client.login
          redirect_to @client
        else
          render :new_login
        end
      end
    end
  end

  def card
    authorize! :manage, Client

    @client = Client.find(params[:id].to_i)
    respond_to do |format|
      if @client.login
        format.html { render layout: 'card' }
      else
        flash[:error] = "#{@client.current_alias} has no login yet."
        redirect_to @client
      end
    end
  end

  def purchases
    authorize! :show, Client
    authorize! :show, StoreCart

    @client = Client.find(params[:id])
    @carts = @client.purchases

    respond_to do |format|
      format.html
      format.json { render json: @carts }
    end
  end

  private

  def sort_column
    default = "current_alias"
    return default unless params[:sort]

    Client.column_names.include?(params[:sort]) ?
      params[:sort] : "current_alias"
  end

  def sort_direction
    default = "asc"
    return default unless params[:direction]

    %{asc desc}.include?(params[:direction]) ? params[:direction] : "asc"
  end
end
