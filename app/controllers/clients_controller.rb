require 'open-uri'

# Finding and CRUDing clients
class ClientsController < ApplicationController
  before_filter :require_user
  authorize_resource
  helper_method :sort_column, :sort_direction

  # GET /all
  # GET /all.json
  def all
    load_clients
    load_preferences
  end

  # GET /clients
  # GET /clients.json
  def index
    load_clients
    load_preferences
  end

  # GET /search
  # GET /search.json
  def search
    find_clients
    render_clients
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    load_client
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    build_client
  end

  def entry
    load_client
    build_points_entry
  end

  # GET /clients/1/edit
  def edit
    authorize! :update, Client
    load_client
  end

  # POST /clients
  # POST /clients.json
  def create
    authorize! :create, Client
    build_client
    save_client or render :new
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    authorize! :update, Client
    load_client
    build_client
    save_client or render :edit
  end

  def checkin_code
    authorize! :manage, Client
    load_client
    @client.update_checkin_code!
    redirect_to @client
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    authorize! :destroy, Client
    load_client
    @client.destroy

    redirect_to clients_url
  end

  # GET /clients/1/entries
  # GET /clients/1/entries.json
  def entries
    load_client
    @entries = @client.points_entries.page params[:page]
    @prefs = current_user.preference_for :client_fields
  end

  def checkins
    authorize! :show, Checkin
    load_client
    @checkins = @client.checkins.order('checkin_at DESC').page params[:page]
  end

  def flags
    authorize! :show, ClientFlag
    load_client
    @flags = @client.flags.order('expires_on DESC')
  end

  def new_login
    authorize! :create, User
    load_client
  end

  def create_login
    authorize! :create, User
    load_client
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

    load_client
    # open(@client.organization.card_template.url) { |io| content = io.read }
    @picture_url = if @client.picture_file_name
                     @client.picture.url(:square)
                   else
                      "https://s3.amazonaws.com/elasticbeanstalk-us-east-1-820256515611/" +
                      "marys-place/avatars/thumb/blank.png"
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
    load_client
  end

  private

  def client_params
    client_params = params[:client]

    if client_params
      client_params.permit(:current_alias,
                           :full_name,
                           :other_aliases,
                           :oriented_on,
                           :birthday,
                           :phone_number,
                           :notes,
                           :is_active,
                           :organization_id,
                           :case_manager_info,
                           :family_info,
                           :community_goal,
                           :email_address,
                           :emergency_contact,
                           :medical_info,
                           :mailing_list_address,
                           :personal_goal,
                           :signed_covenant,
                           :staying_at,
                           :on_mailing_list,
                           :picture,
                           :picture_file_name)
    else
      {}
    end
  end

  def load_clients
    sort_rule = "#{sort_column} #{sort_direction}"
    @clients ||= Client.filtered_by(params[:filters])
        .order(sort_rule).page params[:page]
  end

  def find_clients
    @query ||= params[:q]
    @clients = Client.quicksearch @query
  end

  def load_client
    @client ||= Client.find params[:id]
  end

  def build_client
    @client ||= Client.new
    @client.attributes = client_params
    @client.added_by ||= current_user
  end

  def render_clients
    respond_to do |format|
      format.html # search.html.haml
      format.json {
        render json: @clients.map { |client| client.to_hash }
      }
    end
  end

  def save_client
    if @client.save
      redirect_to @client
    end
  end

  def load_preferences
    @prefs ||= current_user.preference_for :client_fields
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

  def build_points_entry
    @points_entry ||= PointsEntry.new
    @points_entry_type ||= PointsEntryType.new
    @points_entry.client ||= @client
  end
end
