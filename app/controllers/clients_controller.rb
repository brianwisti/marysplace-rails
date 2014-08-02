require 'open-uri'

# /clients
class ClientsController < ApplicationController
  before_filter :require_user
  authorize_resource
  helper_method :sort_column, :sort_direction

  # GET /all
  # GET /all.json
  def all
    load_clients
    @prefs = current_user.preference_for :client_fields
  end

  # GET /clients
  # GET /clients.json
  def index
    load_clients
    @prefs = current_user.preference_for :client_fields
  end

  # GET /search
  # GET /search.json
  def search
    @query = params[:q]
    @clients = Client.quicksearch(@query)
    mapping = @clients.map { |c| c.to_hash }

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
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new
  end

  def entry
    @client = Client.find(params[:id])
    @points_entry = PointsEntry.new
    @points_entry_type = PointsEntryType.new
    @points_entry.client = @client
  end

  # GET /clients/1/edit
  def edit
    authorize! :update, Client
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
    authorize! :create, Client
    @client = Client.new(params[:client])
    @client.added_by_id = current_user.id

    if @client.save
      redirect_to @client, notice: 'Client was successfully created.'
    else
      render :new
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    authorize! :update, Client
    @client = Client.find(params[:id])

    if @client.update_attributes(params[:client])
        redirect_to @client, notice: 'Client was successfully updated.'
    else
      render :edit
    end
  end

  def checkin_code
    authorize! :manage, Client
    @client = Client.find params[:id]
    @client.update_checkin_code!
    redirect_to @client
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    authorize! :destroy, Client
    @client = Client.find(params[:id])
    @client.destroy

    redirect_to clients_url
  end

  # GET /clients/1/entries
  # GET /clients/1/entries.json
  def entries
    @client = Client.find(params[:id])
    @entries = @client.points_entries.page params[:page]
    @prefs = current_user.preference_for :client_fields
  end

  def checkins
    authorize! :show, Checkin
    @client = Client.find(params[:id])
    @checkins = @client.checkins.order('checkin_at DESC').page params[:page]
  end

  def flags
    authorize! :show, ClientFlag
    @client = Client.find(params[:id])
    @flags = @client.client_flags.order('expires_on DESC')
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


    if @client.login
      redirect_to @client
    else
      render :new_login
    end
  end

  def barcode
    @client = Client.find params[:id]
  end

  def card
    authorize! :manage, Client

    @client = Client.find(params[:id].to_i)
    # open(@client.organization.card_template.url) { |io| content = io.read }
    @picture_url = if @client.picture_file_name 
                     @client.picture.url(:square)
                   else
                      "https://s3.amazonaws.com/elasticbeanstalk-us-east-1-820256515611/marys-place/avatars/thumb/blank.png" 
                   end

    respond_to do |format|
      if @client.checkin_code
        format.svg
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
  end

  private

  def load_clients 
    sort_rule = "#{sort_column} #{sort_direction}"
    @clients = Client.filtered_by(params[:filters])
        .order(sort_rule).page params[:page]
  end

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
